import { Request, Response } from 'express';
import { StudentModel } from '../models/Student';
import { IncidentModel } from '../models/Incident';
import { EscalationCaseModel } from '../models/EscalationCase';
import { StudentRemovalModel } from '../models/StudentRemoval';

export class ReportsController {
  static async getDisciplineSummary(req: Request, res: Response) {
    try {
      const totalStudents = await StudentModel.countDocuments();
      const activeStudents = await StudentModel.countDocuments({ status: 'ACTIVE' });
      const underReview = await StudentModel.countDocuments({ status: 'UNDER_REVIEW' });
      const thresholdCases = await StudentModel.countDocuments({ termScore: { $lte: 18 }, status: { $ne: 'REMOVED' } });
      const removedStudents = await StudentModel.countDocuments({ status: 'REMOVED' });
      const pendingDeductions = await IncidentModel.countDocuments({ status: 'PENDING_APPROVAL' });

      return res.json({
        success: true,
        data: {
          totalStudents,
          activeStudents,
          underReview,
          thresholdCases,
          removedStudents,
          pendingDeductions,
        },
      });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async getThresholdReport(req: Request, res: Response) {
    try {
      const cases = await EscalationCaseModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: cases });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async getRemovalsReport(req: Request, res: Response) {
    try {
      const removals = await StudentRemovalModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: removals });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }
}
