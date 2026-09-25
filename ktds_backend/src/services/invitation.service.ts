import { InvitationModel, InvitationStatus } from '../models/Invitation';
import { UserRole } from '../models/User';
import { AuditLogModel } from '../models/AuditLog';

export class InvitationService {
  static async createInvitation(data: {
    name: string;
    email: string;
    role: UserRole;
    createdBy: string;
  }) {
    if (data.role === UserRole.ADMIN || data.role === UserRole.SCHOOL_MANAGER) {
      throw new Error('Cannot create referral invitations for Admin or School Manager');
    }

    let referralCode = '';
    let isUnique = false;
    let attempts = 0;

    while (!isUnique && attempts < 20) {
      referralCode = Math.floor(10000 + Math.random() * 90000).toString();
      const existing = await InvitationModel.findOne({ referralCode });
      if (!existing) {
        isUnique = true;
      }
      attempts++;
    }

    if (!isUnique) {
      throw new Error('Failed to generate a unique 5-digit referral code. Please try again.');
    }

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // Valid for 7 days

    const invitation = await InvitationModel.create({
      referralCode,
      name: data.name,
      email: data.email.toLowerCase(),
      role: data.role,
      status: InvitationStatus.PENDING,
      expiresAt,
      createdBy: data.createdBy,
    });

    await AuditLogModel.create({
      userId: data.createdBy,
      userRole: UserRole.ADMIN,
      action: 'CREATE_REFERRAL_INVITATION',
      details: `Generated 5-digit referral code ${referralCode} for ${data.email} (${data.role})`,
    });

    return invitation;
  }

  static async listInvitations() {
    return InvitationModel.find().sort({ createdAt: -1 });
  }

  static async revokeInvitation(id: string, adminUserId: string) {
    const invitation = await InvitationModel.findById(id);
    if (!invitation) {
      throw new Error('Invitation not found');
    }

    invitation.status = InvitationStatus.REVOKED;
    await invitation.save();

    await AuditLogModel.create({
      userId: adminUserId,
      userRole: UserRole.ADMIN,
      action: 'REVOKE_REFERRAL_INVITATION',
      details: `Revoked referral code ${invitation.referralCode} for ${invitation.email}`,
    });

    return invitation;
  }
}
