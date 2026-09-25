import { StudentModel } from '../models/Student';
import { EscalationCaseModel, EscalationStatus } from '../models/EscalationCase';
import { NotificationModel, NotificationType } from '../models/Notification';
import { WhatsAppMessageType } from '../models/WhatsAppMessage';
import { UserRole } from '../models/User';
import { PdfService } from './letter.service';
import { WhatsAppService } from './whatsapp.service';
import { AuditLogModel } from '../models/AuditLog';

export class ThresholdService {
  static async checkAndTrigger18Threshold(studentId: string): Promise<void> {
    const student = await StudentModel.findOne({ studentId });
    if (!student) return;

    if (student.termScore <= 18) {
      // Check if an open escalation case already exists for this threshold
      const existingOpenCase = await EscalationCaseModel.findOne({
        studentId: student.studentId,
        status: { $in: [EscalationStatus.OPEN, EscalationStatus.UNDER_REVIEW] },
      });

      if (existingOpenCase) {
        console.log(`[threshold]: Open escalation case already exists for student ${studentId}.`);
        return;
      }

      // 1. Generate 18/40 PDF letter
      const parentContact = student.parentContacts?.[0];
      const pdfUrl = await PdfService.generate18Over40Letter({
        studentId: student.studentId,
        studentName: `${student.firstName} ${student.lastName}`,
        className: student.className,
        currentScore: student.termScore,
        parentName: parentContact?.name,
      });

      // 2. Send automatic WhatsApp notice to parent with PDF
      let whatsAppStatus = 'SKIPPED';
      if (parentContact?.whatsappNumber) {
        const messageText =
          `KAGEYO TSS – DISCIPLINE NOTICE\n\n` +
          `Dear Parent/Guardian,\n\n` +
          `This is to inform you that your child ${student.firstName} ${student.lastName} (${student.className}) ` +
          `has reached a discipline score of ${student.termScore}/40.\n\n` +
          `An official school letter is attached. Please contact Kageyo TSS Management.`;

        const waMsg = await WhatsAppService.sendMessage({
          studentId: student.studentId,
          parentContactPhone: parentContact.whatsappNumber,
          messageType: WhatsAppMessageType.DISCIPLINE_18_40,
          messageText,
          documentUrl: pdfUrl,
        });
        whatsAppStatus = waMsg.status;
      }

      // 3. Create Escalation Case
      const caseId = `ESC-${student.studentId}-${Date.now().toString().slice(-4)}`;
      await EscalationCaseModel.create({
        caseId,
        studentId: student.studentId,
        studentName: `${student.firstName} ${student.lastName}`,
        className: student.className,
        currentScore: student.termScore,
        status: EscalationStatus.OPEN,
        pdfLetterUrl: pdfUrl,
        whatsAppStatus,
      });

      // 4. Send Internal Staff Notifications
      await NotificationModel.create({
        targetRole: UserRole.SCHOOL_MANAGER,
        type: NotificationType.THRESHOLD,
        title: `18/40 Threshold Alert: ${student.firstName} ${student.lastName}`,
        message: `Student ${student.firstName} ${student.lastName} (${student.className}) reached ${student.termScore}/40. Escalation case created & parent notified via WhatsApp.`,
        relatedEntityId: caseId,
      });

      // 5. Audit Log
      await AuditLogModel.create({
        userId: 'SYSTEM_AUTOMATION',
        userRole: 'SYSTEM',
        action: 'AUTOMATIC_18_THRESHOLD_TRIGGERED',
        details: `Discipline score dropped to ${student.termScore}/40 for student ${student.studentId}. Generated PDF: ${pdfUrl}`,
      });
    }
  }
}
