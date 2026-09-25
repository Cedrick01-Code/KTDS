import { Request, Response } from 'express';
import { SchoolService } from '../services/school.service';

export class SchoolController {
  static async setup(req: Request, res: Response) {
    try {
      const result = await SchoolService.setupSchool(req.body);
      res.status(201).json({
        success: true,
        data: result,
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        message: error.message,
      });
    }
  }

  static async getInfo(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const school = await SchoolService.getSchoolInfo(id as string);
      if (!school) {
        return res.status(404).json({
          success: false,
          message: 'School not found',
        });
      }
      res.json({
        success: true,
        data: school,
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }
}
