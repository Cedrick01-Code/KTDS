import { StudentModel, StudentStatus } from '../models/Student';
import { StudentRemovalModel } from '../models/StudentRemoval';
import { NotificationModel, NotificationType } from '../models/Notification';
import { WhatsAppMessageType } from '../models/WhatsAppMessage';
import { UserRole } from '../models/User';
import { PdfService } from './letter.service';
import { WhatsAppService } from './whatsapp.service';
import { AuditLogModel } from '../models/AuditLog';

export class RemovalService {
  static async removeStudent(data: {
    studentId: string;
    removedBy: string;
    removedByName: string;
    category: string;
    reason: string;
    evidenceUrl?: string;
  }) {
    const student = await StudentModel.findOne({ studentId: data.studentId });
    if (!student) {
      throw new Error('Student not found');
    }

    if (student.status === StudentStatus.REMOVED) {
      throw new Error('Student is already removed');
    }

    // 1. Update Student status
    student.status = StudentStatus.REMOVED;
    await student.save();

    // 2. Generate Official Removal PDF
    const pdfUrl = await PdfService.generateRemovalLetter({
      studentId: student.studentId,
      studentName: `${student.firstName} ${student.lastName}`,
      className: student.className,
      category: data.category,
      reason: data.reason,
      removedByName: data.removedByName,
    });

    // 3. Send WhatsApp notice to parent
    const parentContact = student.parentContacts?.[0];
    let whatsAppStatus = 'SKIPPED';
    if (parentContact?.whatsappNumber) {
      const messageText =
        `KAGEYO TSS – OFFICIAL NOTICE\n\n` +
        `Dear Parent/Guardian,\n\n` +
        `This is to inform you that student ${student.firstName} ${student.lastName} (${student.className}) ` +
        `has been officially REMOVED from Kageyo TSS following a disciplinary decision.\n\n` +
        `Please find the official school letter attached.`;

      const waMsg = await WhatsAppService.sendMessage({
        studentId: student.studentId,
        parentContactPhone: parentContact.whatsappNumber,
        messageType: WhatsAppMessageType.STUDENT_REMOVAL,
        messageText,
        documentUrl: pdfUrl,
      });
      whatsAppStatus = waMsg.status;
    }

    // 4. Create Removal Record
    const removalId = `REM-${student.studentId}-${Date.now().toString().slice(-4)}`;
    const removal = await StudentRemovalModel.create({
      removalId,
      studentId: student.studentId,
      studentName: `${student.firstName} ${student.lastName}`,
      className: student.className,
      removedBy: data.removedBy,
      removedByName: data.removedByName,
      category: data.category,
      reason: data.reason,
      evidenceUrl: data.evidenceUrl,
      pdfLetterUrl: pdfUrl,
      whatsAppStatus,
    });

    // 5. Send Internal Staff Notification
    await NotificationModel.create({
      targetRole: UserRole.ADMIN,
      type: NotificationType.STUDENT_REMOVAL,
      title: `Student Removed: ${student.firstName} ${student.lastName}`,
      message: `${data.removedByName} removed student ${student.firstName} ${student.lastName} (${student.className}) for ${data.category}.`,
      relatedEntityId: removalId,
    });

    // 6. Audit Log
    await AuditLogModel.create({
      userId: data.removedBy,
      userRole: UserRole.SCHOOL_MANAGER,
      action: 'REMOVE_STUDENT',
      details: `Removed student ${student.studentId} (${data.category}). PDF: ${pdfUrl}`,
    });

    return removal;
  }
}
