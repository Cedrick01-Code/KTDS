import { Request, Response } from 'express';
import { WhatsAppMessageModel } from '../models/WhatsAppMessage';

export class WhatsAppController {
  static async listMessages(req: Request, res: Response) {
    try {
      const messages = await WhatsAppMessageModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: messages });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }
}
