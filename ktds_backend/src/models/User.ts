import { Schema, model, Document } from 'mongoose';

export enum UserRole {
  ADMIN = 'ADMIN',
  SCHOOL_MANAGER = 'SCHOOL_MANAGER',
  TEACHER = 'TEACHER',
  DOD = 'DOD',
  PATRON = 'PATRON',
  MATRON = 'MATRON',
}

export interface IUser extends Document {
  name: string;
  email: string;
  phone?: string;
  passwordHash: string;
  role: UserRole;
  isActive: boolean;
  mustChangePassword?: boolean;
  assignedClassName?: string;
  lastLoginAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const userSchema = new Schema<IUser>(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    phone: { type: String, trim: true },
    passwordHash: { type: String, required: true },
    role: {
      type: String,
      enum: Object.values(UserRole),
      required: true,
    },
    isActive: { type: Boolean, default: true },
    mustChangePassword: { type: Boolean, default: false },
    assignedClassName: { type: String },
    lastLoginAt: { type: Date },
  },
  { timestamps: true }
);

export const UserModel = model<IUser>('User', userSchema);
