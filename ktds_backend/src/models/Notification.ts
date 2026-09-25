import { Schema, model, Document } from 'mongoose';

export enum NotificationType {
  DEDUCTION = 'DEDUCTION',
  APPROVAL = 'APPROVAL',
  REJECTION = 'REJECTION',
  THRESHOLD = 'THRESHOLD',
  MANAGER_ACTION = 'MANAGER_ACTION',
  PARENT_NOTIFICATION = 'PARENT_NOTIFICATION',
  STUDENT_REMOVAL = 'STUDENT_REMOVAL',
  ANNOUNCEMENT = 'ANNOUNCEMENT',
  SYSTEM = 'SYSTEM',
}

export interface INotification extends Document {
  userId?: string;
  targetRole?: string;
  type: NotificationType;
  title: string;
  message: string;
  relatedEntityId?: string;
  isRead: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const notificationSchema = new Schema<INotification>(
  {
    userId: { type: String },
    targetRole: { type: String },
    type: {
      type: String,
      enum: Object.values(NotificationType),
      required: true,
    },
    title: { type: String, required: true },
    message: { type: String, required: true },
    relatedEntityId: { type: String },
    isRead: { type: Boolean, default: false },
  },
  { timestamps: true }
);

export const NotificationModel = model<INotification>('Notification', notificationSchema);
