import { Schema, model, Document } from 'mongoose';

export enum IncidentStatus {
  PENDING_APPROVAL = 'PENDING_APPROVAL',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED',
  DIRECT_APPLIED = 'DIRECT_APPLIED',
}

export interface IIncident extends Document {
  studentId: string;
  category: string;
  description: string;
  points: number;
  status: IncidentStatus;
  recordedBy: string;
  recordedByName: string;
  recordedByRole: string;
  rejectionReason?: string;
  evidenceUrl?: string;
  createdAt: Date;
  updatedAt: Date;
}

const incidentSchema = new Schema<IIncident>(
  {
    studentId: { type: String, required: true, ref: 'Student' },
    category: { type: String, required: true },
    description: { type: String, required: true },
    points: { type: Number, required: true, min: 1, max: 40 },
    status: {
      type: String,
      enum: Object.values(IncidentStatus),
      default: IncidentStatus.PENDING_APPROVAL,
    },
    recordedBy: { type: String, required: true },
    recordedByName: { type: String, required: true },
    recordedByRole: { type: String, required: true },
    rejectionReason: { type: String },
    evidenceUrl: { type: String },
  },
  { timestamps: true }
);

export const IncidentModel = model<IIncident>('Incident', incidentSchema);
