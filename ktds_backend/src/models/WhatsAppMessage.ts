import { Schema, model, Document } from 'mongoose';

export enum WhatsAppStatus {
  PENDING = 'PENDING',
  SENT = 'SENT',
  DELIVERED = 'DELIVERED',
  READ = 'READ',
  FAILED = 'FAILED',
}

export enum WhatsAppMessageType {
  DISCIPLINE_18_40 = 'DISCIPLINE_18_40',
  STUDENT_REMOVAL = 'STUDENT_REMOVAL',
  ANNOUNCEMENT = 'ANNOUNCEMENT',
  OTHER = 'OTHER',
}

export interface IWhatsAppMessage extends Document {
  studentId: string;
  parentContactPhone: string;
  messageType: WhatsAppMessageType;
  messageText: string;
  documentUrl?: string;
  providerMessageId?: string;
  status: WhatsAppStatus;
  errorMessage?: string;
  sentAt?: Date;
  deliveredAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const whatsAppMessageSchema = new Schema<IWhatsAppMessage>(
  {
    studentId: { type: String, required: true },
    parentContactPhone: { type: String, required: true },
    messageType: {
      type: String,
      enum: Object.values(WhatsAppMessageType),
      required: true,
    },
    messageText: { type: String, required: true },
    documentUrl: { type: String },
    providerMessageId: { type: String },
    status: {
      type: String,
      enum: Object.values(WhatsAppStatus),
      default: WhatsAppStatus.PENDING,
    },
    errorMessage: { type: String },
    sentAt: { type: Date },
    deliveredAt: { type: Date },
  },
  { timestamps: true }
);

export const WhatsAppMessageModel = model<IWhatsAppMessage>('WhatsAppMessage', whatsAppMessageSchema);
