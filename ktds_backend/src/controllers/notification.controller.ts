import { Request, Response } from 'express';
import { NotificationModel } from '../models/Notification';

export class NotificationController {
  static async listNotifications(req: Request, res: Response) {
    try {
      const notifications = await NotificationModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: notifications });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async markAsRead(req: Request, res: Response) {
    try {
      const notif = await NotificationModel.findByIdAndUpdate(
        req.params.id,
        { isRead: true },
        { new: true }
      );
      return res.json({ success: true, data: notif });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }
}
