import { Request, Response } from 'express';
import { AuditLogModel } from '../models/AuditLog';

export class AuditController {
  static async listAuditLogs(req: Request, res: Response) {
    try {
      const logs = await AuditLogModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: logs });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }
}
