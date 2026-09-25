import prisma from '../utils/prisma';
import { UserRole } from '@prisma/client';

export class AuditService {
  static async logAction(data: {
    schoolId: string;
    userId: string;
    userRole: UserRole;
    action: string;
    entityType: string;
    entityId?: string;
    previousValue?: any;
    newValue?: any;
    reason?: string;
  }) {
    return prisma.auditLog.create({
      data: {
        schoolId: data.schoolId,
        userId: data.userId,
        userRole: data.userRole,
        action: data.action,
        entityType: data.entityType,
        entityId: data.entityId,
        previousValue: data.previousValue,
        newValue: data.newValue,
        reason: data.reason,
      },
    });
  }

  static async getLogs(schoolId: string) {
    return prisma.auditLog.findMany({
      where: { schoolId },
      orderBy: { timestamp: 'desc' },
      take: 100,
    });
  }
}
