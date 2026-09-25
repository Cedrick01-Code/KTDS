import { Schema, model, Document } from 'mongoose';

export enum EscalationStatus {
  OPEN = 'OPEN',
  UNDER_REVIEW = 'UNDER_REVIEW',
  RESOLVED = 'RESOLVED',
  CLOSED = 'CLOSED',
}

export interface IEscalationCase extends Document {
  caseId: string;
  studentId: string;
  studentName: string;
  className: string;
  currentScore: number;
  status: EscalationStatus;
  pdfLetterUrl?: string;
  whatsAppStatus: string;
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

const escalationCaseSchema = new Schema<IEscalationCase>(
  {
    caseId: { type: String, required: true, unique: true },
    studentId: { type: String, required: true },
    studentName: { type: String, required: true },
    className: { type: String, required: true },
    currentScore: { type: Number, required: true },
    status: {
      type: String,
      enum: Object.values(EscalationStatus),
      default: EscalationStatus.OPEN,
    },
    pdfLetterUrl: { type: String },
    whatsAppStatus: { type: String, default: 'PENDING' },
    notes: { type: String },
  },
  { timestamps: true }
);

export const EscalationCaseModel = model<IEscalationCase>('EscalationCase', escalationCaseSchema);
