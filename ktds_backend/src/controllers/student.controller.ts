import { Request, Response } from 'express';
import { StudentModel } from '../models/Student';
import { RemovalService } from '../services/removal.service';

export class StudentController {
  static async listStudents(req: Request, res: Response) {
    try {
      const students = await StudentModel.find().sort({ firstName: 1 });
      return res.json({ success: true, data: students });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async getStudent(req: Request, res: Response) {
    try {
      const student = await StudentModel.findOne({ studentId: req.params.id });
      if (!student) {
        return res.status(404).json({ success: false, error: { message: 'Student not found' } });
      }
      return res.json({ success: true, data: student });
    } catch (error: any) {
      return res.status(500).json({ success: false, error: { message: error.message } });
    }
  }

  static async createStudent(req: Request, res: Response) {
    try {
      const { studentId, firstName, lastName, className, parentContacts } = req.body;
      if (!studentId || !firstName || !lastName || !className) {
        return res.status(400).json({ success: false, error: { message: 'Missing required student fields' } });
      }
      const newStudent = await StudentModel.create({
        studentId,
        firstName,
        lastName,
        className,
        parentContacts: parentContacts || [],
      });
      return res.status(201).json({ success: true, data: newStudent });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async removeStudent(req: Request, res: Response) {
    try {
      const { category, reason, evidenceUrl } = req.body;
      const removedBy = (req as any).user?.userId || 'MANAGER';
      const removedByName = (req as any).user?.name || 'School Manager';

      if (!category || !reason) {
        return res.status(400).json({ success: false, error: { message: 'Category and reason are required' } });
      }

      const removal = await RemovalService.removeStudent({
        studentId: req.params.id,
        removedBy,
        removedByName,
        category,
        reason,
        evidenceUrl,
      });

      return res.json({ success: true, data: removal });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }
}
