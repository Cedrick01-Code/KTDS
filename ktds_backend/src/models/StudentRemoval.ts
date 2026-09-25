import { Schema, model, Document } from 'mongoose';

export interface IStudentRemoval extends Document {
  removalId: string;
  studentId: string;
  studentName: string;
  className: string;
  removedBy: string;
  removedByName: string;
  category: string;
  reason: string;
  evidenceUrl?: string;
  pdfLetterUrl?: string;
  whatsAppStatus: string;
  createdAt: Date;
  updatedAt: Date;
}

const studentRemovalSchema = new Schema<IStudentRemoval>(
  {
    removalId: { type: String, required: true, unique: true },
    studentId: { type: String, required: true },
    studentName: { type: String, required: true },
    className: { type: String, required: true },
    removedBy: { type: String, required: true },
    removedByName: { type: String, required: true },
    category: { type: String, required: true },
    reason: { type: String, required: true },
    evidenceUrl: { type: String },
    pdfLetterUrl: { type: String },
    whatsAppStatus: { type: String, default: 'PENDING' },
  },
  { timestamps: true }
);

export const StudentRemovalModel = model<IStudentRemoval>('StudentRemoval', studentRemovalSchema);
