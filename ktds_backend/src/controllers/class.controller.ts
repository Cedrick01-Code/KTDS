import { Request, Response } from 'express';
import { ClassService } from '../services/class.service';

export class ClassController {
  static async create(req: Request, res: Response) {
    try {
      const newClass = await ClassService.createClass(req.body);
      res.status(201).json({ success: true, data: newClass });
    } catch (error: any) {
      res.status(400).json({ success: false, message: error.message });
    }
  }

  static async list(req: Request, res: Response) {
    try {
      const { schoolId, academicYearId } = req.query;
      const classes = await ClassService.listClasses(schoolId as string, academicYearId as string);
      res.json({ success: true, data: classes });
    } catch (error: any) {
      res.status(500).json({ success: false, message: error.message });
    }
  }

  static async assignTeacher(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { teacherId } = req.body;
      const updatedClass = await ClassService.assignClassTeacher(id as string, teacherId);
      res.json({ success: true, data: updatedClass });
    } catch (error: any) {
      res.status(400).json({ success: false, message: error.message });
    }
  }
}
