import { IncidentModel, IncidentStatus } from '../models/Incident';
import { StudentModel } from '../models/Student';
import { NotificationModel, NotificationType } from '../models/Notification';
import { UserRole } from '../models/User';
import { ThresholdService } from './threshold.service';
import { AuditLogModel } from '../models/AuditLog';

export class DisciplineService {
  static async recordIncident(data: {
    studentId: string;
    category: string;
    description: string;
    points: number;
    recordedBy: string;
    recordedByName: string;
    recordedByRole: UserRole;
    evidenceUrl?: string;
  }) {
    const student = await StudentModel.findOne({ studentId: data.studentId });
    if (!student) {
      throw new Error('Student not found');
    }

    const isDirectDeduction =
      data.recordedByRole === UserRole.DOD ||
      data.recordedByRole === UserRole.PATRON ||
      data.recordedByRole === UserRole.MATRON;

    const initialStatus = isDirectDeduction
      ? IncidentStatus.DIRECT_APPLIED
      : IncidentStatus.PENDING_APPROVAL;

    const incident = await IncidentModel.create({
      studentId: data.studentId,
      category: data.category,
      description: data.description,
      points: data.points,
      status: initialStatus,
      recordedBy: data.recordedBy,
      recordedByName: data.recordedByName,
      recordedByRole: data.recordedByRole,
      evidenceUrl: data.evidenceUrl,
    });

    if (isDirectDeduction) {
      // Apply score reduction immediately
      student.termScore = Math.max(0, student.termScore - data.points);
      await student.save();

      // Trigger threshold check automatically if score drops <= 18
      await ThresholdService.checkAndTrigger18Threshold(student.studentId);

      // Audit log
      await AuditLogModel.create({
        userId: data.recordedBy,
        userRole: data.recordedByRole,
        action: 'DIRECT_DEDUCTION_APPLIED',
        details: `Directly deducted ${data.points} points from student ${student.studentId}. New score: ${student.termScore}`,
      });
    } else {
      // Notify Admin/Manager for approval
      await NotificationModel.create({
        targetRole: UserRole.ADMIN,
        type: NotificationType.DEDUCTION,
        title: `Pending Teacher Deduction: ${student.firstName} ${student.lastName}`,
        message: `${data.recordedByName} submitted a ${data.points}-point deduction request for ${data.category}.`,
        relatedEntityId: incident._id.toString(),
      });
    }

    return incident;
  }

  static async approveTeacherDeduction(incidentId: string, adminUserId: string) {
    const incident = await IncidentModel.findById(incidentId);
    if (!incident) {
      throw new Error('Incident not found');
    }

    if (incident.status !== IncidentStatus.PENDING_APPROVAL) {
      throw new Error(`Incident status is ${incident.status}, cannot approve.`);
    }

    incident.status = IncidentStatus.APPROVED;
    await incident.save();

    const student = await StudentModel.findOne({ studentId: incident.studentId });
    if (student) {
      student.termScore = Math.max(0, student.termScore - incident.points);
      await student.save();

      // Trigger threshold check automatically if score drops <= 18
      await ThresholdService.checkAndTrigger18Threshold(student.studentId);
    }

    // Notify Teacher
    await NotificationModel.create({
      userId: incident.recordedBy,
      type: NotificationType.APPROVAL,
      title: 'Teacher Deduction Approved',
      message: `Your ${incident.points}-point deduction for student ${incident.studentId} was approved.`,
      relatedEntityId: incident._id.toString(),
    });

    // Audit Log
    await AuditLogModel.create({
      userId: adminUserId,
      userRole: UserRole.ADMIN,
      action: 'APPROVE_TEACHER_DEDUCTION',
      details: `Approved ${incident.points}-point deduction for incident ${incidentId}`,
    });

    return incident;
  }

  static async rejectTeacherDeduction(incidentId: string, adminUserId: string, reason: string) {
    const incident = await IncidentModel.findById(incidentId);
    if (!incident) {
      throw new Error('Incident not found');
    }

    if (incident.status !== IncidentStatus.PENDING_APPROVAL) {
      throw new Error(`Incident status is ${incident.status}, cannot reject.`);
    }

    incident.status = IncidentStatus.REJECTED;
    incident.rejectionReason = reason;
    await incident.save();

    // Notify Teacher
    await NotificationModel.create({
      userId: incident.recordedBy,
      type: NotificationType.REJECTION,
      title: 'Teacher Deduction Rejected',
      message: `Your deduction request for student ${incident.studentId} was rejected. Reason: ${reason}`,
      relatedEntityId: incident._id.toString(),
    });

    await AuditLogModel.create({
      userId: adminUserId,
      userRole: UserRole.ADMIN,
      action: 'REJECT_TEACHER_DEDUCTION',
      details: `Rejected deduction for incident ${incidentId}. Reason: ${reason}`,
    });

    return incident;
  }
}
