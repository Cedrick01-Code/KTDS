import { Request, Response } from 'express';
import { EscalationCaseModel } from '../models/EscalationCase';

export class EscalationController {
  static async listEscalationCases(req: Request, res: Response) {
    try {
      const cases = await EscalationCaseModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: cases });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async getEscalationCase(req: Request, res: Response) {
    try {
      const escalationCase = await EscalationCaseModel.findOne({ caseId: req.params.id });
      if (!escalationCase) {
        return res.status(404).json({ success: false, error: { message: 'Escalation case not found' } });
      }
      return res.json({ success: true, data: escalationCase });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }
}
