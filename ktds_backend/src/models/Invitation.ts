import { Schema, model, Document } from 'mongoose';
import { UserRole } from './User';

export enum InvitationStatus {
  PENDING = 'PENDING',
  USED = 'USED',
  EXPIRED = 'EXPIRED',
  REVOKED = 'REVOKED',
}

export interface IInvitation extends Document {
  referralCode: string;
  referralCodeHash?: string;
  name: string;
  email: string;
  role: UserRole;
  status: InvitationStatus;
  expiresAt: Date;
  createdBy: string;
  usedAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const invitationSchema = new Schema<IInvitation>(
  {
    referralCode: { type: String, required: true, unique: true },
    referralCodeHash: { type: String },
    name: { type: String, required: true },
    email: { type: String, required: true, lowercase: true, trim: true },
    role: {
      type: String,
      enum: [UserRole.TEACHER, UserRole.DOD, UserRole.PATRON, UserRole.MATRON],
      required: true,
    },
    status: {
      type: String,
      enum: Object.values(InvitationStatus),
      default: InvitationStatus.PENDING,
    },
    expiresAt: { type: Date, required: true },
    createdBy: { type: String, required: true },
    usedAt: { type: Date },
  },
  { timestamps: true }
);

export const InvitationModel = model<IInvitation>('Invitation', invitationSchema);
