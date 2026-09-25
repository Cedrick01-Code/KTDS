import { Schema, model, Document } from 'mongoose';

export interface IAuditLog extends Document {
  userId: string;
  userEmail?: string;
  userRole: string;
  action: string;
  entityType?: string;
  entityId?: string;
  details?: string;
  ipAddress?: string;
  createdAt: Date;
}

const auditLogSchema = new Schema<IAuditLog>(
  {
    userId: { type: String, required: true },
    userEmail: { type: String },
    userRole: { type: String, required: true },
    action: { type: String, required: true },
    entityType: { type: String },
    entityId: { type: String },
    details: { type: String },
    ipAddress: { type: String },
  },
  { timestamps: true }
);

export const AuditLogModel = model<IAuditLog>('AuditLog', auditLogSchema);
