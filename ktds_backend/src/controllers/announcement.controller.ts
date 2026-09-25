import { Request, Response } from 'express';
import { AnnouncementService } from '../services/announcement.service';

export class AnnouncementController {
  static async create(req: Request, res: Response) {
    try {
      const announcement = await AnnouncementService.createAnnouncement(req.body);
      res.status(201).json({ success: true, data: announcement });
    } catch (error: any) {
      res.status(400).json({ success: false, message: error.message });
    }
  }

  static async list(req: Request, res: Response) {
    try {
      const { schoolId, audience } = req.query;
      const announcements = await AnnouncementService.listAnnouncements(
        schoolId as string,
        audience as string
      );
      res.json({ success: true, data: announcements });
    } catch (error: any) {
      res.status(500).json({ success: false, message: error.message });
    }
  }
}
