import { Schema, model, Document } from 'mongoose';

export enum StudentStatus {
  ACTIVE = 'ACTIVE',
  UNDER_REVIEW = 'UNDER_REVIEW',
  DISCIPLINARY_CASE = 'DISCIPLINARY_CASE',
  REMOVED = 'REMOVED',
  GRADUATED = 'GRADUATED',
}

export interface IParentContact {
  name: string;
  relationship: string;
  whatsappNumber: string;
  whatsappEnabled: boolean;
}

export interface IStudent extends Document {
  studentId: string;
  firstName: string;
  lastName: string;
  className: string;
  termScore: number;
  maxScore: number;
  disciplineThreshold: number;
  status: StudentStatus;
  parentContacts: IParentContact[];
  createdAt: Date;
  updatedAt: Date;
}

const parentContactSchema = new Schema<IParentContact>({
  name: { type: String, required: true },
  relationship: { type: String, required: true },
  whatsappNumber: { type: String, required: true },
  whatsappEnabled: { type: Boolean, default: true },
});

const studentSchema = new Schema<IStudent>(
  {
    studentId: { type: String, required: true, unique: true, uppercase: true, trim: true },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
    className: { type: String, required: true, trim: true },
    termScore: { type: Number, default: 40, min: 0, max: 40 },
    maxScore: { type: Number, default: 40 },
    disciplineThreshold: { type: Number, default: 18 },
    status: {
      type: String,
      enum: Object.values(StudentStatus),
      default: StudentStatus.ACTIVE,
    },
    parentContacts: [parentContactSchema],
  },
  { timestamps: true }
);

export const StudentModel = model<IStudent>('Student', studentSchema);
