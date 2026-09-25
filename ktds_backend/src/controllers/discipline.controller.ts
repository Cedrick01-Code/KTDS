import { Request, Response } from 'express';
import { DisciplineService } from '../services/discipline.service';
import { IncidentModel } from '../models/Incident';
import { UserRole } from '../models/User';

export class DisciplineController {
  static async recordIncident(req: Request, res: Response) {
    try {
      const { studentId, category, description, points, evidenceUrl, role } = req.body;
      const recordedBy = (req as any).user?.userId || 'STAFF';
      const recordedByName = (req as any).user?.name || 'Staff Member';
      const recordedByRole = (req as any).user?.role || role || UserRole.TEACHER;

      if (!studentId || !category || !points || !description) {
        return res.status(400).json({ success: false, error: { message: 'Missing required incident fields' } });
      }

      const incident = await DisciplineService.recordIncident({
        studentId,
        category,
        description,
        points: Number(points),
        recordedBy,
        recordedByName,
        recordedByRole,
        evidenceUrl,
      });

      return res.status(201).json({ success: true, data: incident });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async listIncidents(req: Request, res: Response) {
    try {
      const incidents = await IncidentModel.find().sort({ createdAt: -1 });
      return res.json({ success: true, data: incidents });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async approveDeduction(req: Request, res: Response) {
    try {
      const adminUserId = (req as any).user?.userId || 'ADMIN';
      const incident = await DisciplineService.approveTeacherDeduction(req.params.id, adminUserId);
      return res.json({ success: true, data: incident });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async rejectDeduction(req: Request, res: Response) {
    try {
      const adminUserId = (req as any).user?.userId || 'ADMIN';
      const { reason } = req.body;
      if (!reason) {
        return res.status(400).json({ success: false, error: { message: 'Rejection reason is required' } });
      }
      const incident = await DisciplineService.rejectTeacherDeduction(req.params.id, adminUserId, reason);
      return res.json({ success: true, data: incident });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }
}
