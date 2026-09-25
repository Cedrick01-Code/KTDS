import { UserRole } from '@prisma/client';
export declare class AuditService {
    static logAction(data: {
        schoolId: string;
        userId: string;
        userRole: UserRole;
        action: string;
        entityType: string;
        entityId?: string;
        previousValue?: any;
        newValue?: any;
        reason?: string;
    }): Promise<{
        id: string;
        schoolId: string;
        userId: string;
        reason: string | null;
        userRole: import(".prisma/client").$Enums.UserRole;
        action: string;
        entityType: string;
        entityId: string | null;
        previousValue: import("@prisma/client/runtime/library").JsonValue | null;
        newValue: import("@prisma/client/runtime/library").JsonValue | null;
        timestamp: Date;
    }>;
    static getLogs(schoolId: string): Promise<{
        id: string;
        schoolId: string;
        userId: string;
        reason: string | null;
        userRole: import(".prisma/client").$Enums.UserRole;
        action: string;
        entityType: string;
        entityId: string | null;
        previousValue: import("@prisma/client/runtime/library").JsonValue | null;
        newValue: import("@prisma/client/runtime/library").JsonValue | null;
        timestamp: Date;
    }[]>;
}
//# sourceMappingURL=audit.service.d.ts.map