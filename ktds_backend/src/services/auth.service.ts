import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { UserModel, UserRole } from '../models/User';
import { InvitationModel, InvitationStatus } from '../models/Invitation';
import { AuditLogModel } from '../models/AuditLog';

const JWT_SECRET = process.env.JWT_SECRET || 'ktds_super_secret_jwt_key_2028';
const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || 'ktds_refresh_secret_key_2028';

export class AuthService {
  static async seedAdminUser(): Promise<void> {
    const adminEmail = process.env.INITIAL_ADMIN_EMAIL || 'kageyotss@gmail.com';
    const adminPassword = process.env.INITIAL_ADMIN_PASSWORD || 'TSSkageyo2028';

    const existingAdmin = await UserModel.findOne({ role: UserRole.ADMIN });
    if (!existingAdmin) {
      const passwordHash = await bcrypt.hash(adminPassword, 12);
      await UserModel.create({
        name: 'Kageyo TSS Admin',
        email: adminEmail,
        passwordHash,
        role: UserRole.ADMIN,
        isActive: true,
        mustChangePassword: true,
      });
      console.log(`[auth]: Initial Admin seeded successfully (${adminEmail})`);
    }
  }

  static async validateInvitation(referralCode: string, email: string, role: UserRole) {
    if (role === UserRole.ADMIN || role === UserRole.SCHOOL_MANAGER) {
      throw new Error('Public registration for Admin or School Manager is strictly prohibited.');
    }

    const invitation = await InvitationModel.findOne({
      referralCode,
      status: InvitationStatus.PENDING,
      expiresAt: { $gt: new Date() },
    });

    if (!invitation) {
      throw new Error('Invalid, expired, or used 5-digit referral code');
    }

    if (invitation.role !== role) {
      throw new Error(`Referral code was generated for ${invitation.role}, not ${role}`);
    }

    if (invitation.email && invitation.email.toLowerCase() !== email.toLowerCase()) {
      throw new Error('Email does not match the invitation record');
    }

    return invitation;
  }

  static async register(data: {
    name: string;
    email: string;
    phone?: string;
    password: string;
    role: UserRole;
    referralCode: string;
  }) {
    const { name, email, phone, password, role, referralCode } = data;

    const invitation = await this.validateInvitation(referralCode, email, role);

    const existingUser = await UserModel.findOne({ email: email.toLowerCase() });
    if (existingUser) {
      throw new Error('Account with this email already exists');
    }

    const passwordHash = await bcrypt.hash(password, 12);

    const user = await UserModel.create({
      name: name || invitation.name,
      email: email.toLowerCase(),
      phone,
      passwordHash,
      role,
      isActive: true,
      mustChangePassword: false,
    });

    invitation.status = InvitationStatus.USED;
    invitation.usedAt = new Date();
    await invitation.save();

    await AuditLogModel.create({
      userId: user._id.toString(),
      userEmail: user.email,
      userRole: user.role,
      action: 'REGISTER_VIA_REFERRAL',
      details: `Registered as ${user.role} using referral code ${referralCode}`,
    });

    return user;
  }

  static async createSchoolManager(adminUserId: string, data: {
    name: string;
    email: string;
    phone?: string;
    password: string;
  }) {
    const existing = await UserModel.findOne({ email: data.email.toLowerCase() });
    if (existing) {
      throw new Error('User with this email already exists');
    }

    const passwordHash = await bcrypt.hash(data.password, 12);
    const manager = await UserModel.create({
      name: data.name,
      email: data.email.toLowerCase(),
      phone: data.phone,
      passwordHash,
      role: UserRole.SCHOOL_MANAGER,
      isActive: true,
      mustChangePassword: true,
    });

    await AuditLogModel.create({
      userId: adminUserId,
      userRole: UserRole.ADMIN,
      action: 'CREATE_SCHOOL_MANAGER',
      details: `Created School Manager ${manager.email}`,
    });

    return manager;
  }

  static async login(emailOrPhone: string, password: string) {
    const user = await UserModel.findOne({
      $or: [
        { email: emailOrPhone.toLowerCase() },
        { phone: emailOrPhone },
      ],
    });

    if (!user || !user.isActive) {
      throw new Error('Invalid credentials or account deactivated');
    }

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      throw new Error('Invalid credentials');
    }

    user.lastLoginAt = new Date();
    await user.save();

    const token = jwt.sign(
      { userId: user._id.toString(), email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '8h' }
    );

    const refreshToken = jwt.sign(
      { userId: user._id.toString() },
      JWT_REFRESH_SECRET,
      { expiresIn: '7d' }
    );

    await AuditLogModel.create({
      userId: user._id.toString(),
      userEmail: user.email,
      userRole: user.role,
      action: 'LOGIN',
    });

    return {
      user: {
        id: user._id.toString(),
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        mustChangePassword: user.mustChangePassword,
        assignedClassName: user.assignedClassName,
      },
      token,
      refreshToken,
    };
  }

  static async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const user = await UserModel.findById(userId);
    if (!user) {
      throw new Error('User not found');
    }

    const isValid = await bcrypt.compare(currentPassword, user.passwordHash);
    if (!isValid) {
      throw new Error('Current password is incorrect');
    }

    user.passwordHash = await bcrypt.hash(newPassword, 12);
    user.mustChangePassword = false;
    await user.save();

    await AuditLogModel.create({
      userId: user._id.toString(),
      userEmail: user.email,
      userRole: user.role,
      action: 'CHANGE_PASSWORD',
    });

    return { message: 'Password changed successfully' };
  }
}
