import { Request, Response } from 'express';
import { InvitationService } from '../services/invitation.service';

export class InvitationController {
  static async createInvitation(req: Request, res: Response) {
    try {
      const createdBy = (req as any).user?.userId || 'ADMIN';
      const { name, email, role } = req.body;
      if (!name || !email || !role) {
        return res.status(400).json({ success: false, error: { message: 'Name, email, and role are required' } });
      }
      const invitation = await InvitationService.createInvitation({ name, email, role, createdBy });
      return res.status(201).json({ success: true, data: invitation });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async listInvitations(req: Request, res: Response) {
    try {
      const list = await InvitationService.listInvitations();
      return res.json({ success: true, data: list });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async revokeInvitation(req: Request, res: Response) {
    try {
      const adminUserId = (req as any).user?.userId || 'ADMIN';
      const { id } = req.params;
      const updated = await InvitationService.revokeInvitation(id, adminUserId);
      return res.json({ success: true, data: updated });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }
}
