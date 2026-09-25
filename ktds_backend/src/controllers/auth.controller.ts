import { Request, Response } from 'express';
import { AuthService } from '../services/auth.service';

export class AuthController {
  static async login(req: Request, res: Response) {
    try {
      const { emailOrPhone, password } = req.body;
      if (!emailOrPhone || !password) {
        return res.status(400).json({ success: false, error: { message: 'Email/Phone and Password are required' } });
      }
      const result = await AuthService.login(emailOrPhone, password);
      return res.json({ success: true, data: result });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async register(req: Request, res: Response) {
    try {
      const { name, email, phone, password, role, referralCode } = req.body;
      if (!email || !password || !role || !referralCode) {
        return res.status(400).json({
          success: false,
          error: { message: 'Email, password, role, and 5-digit referral code are required' },
        });
      }
      const user = await AuthService.register({ name, email, phone, password, role, referralCode });
      return res.status(201).json({ success: true, data: user });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async createSchoolManager(req: Request, res: Response) {
    try {
      const adminUserId = (req as any).user?.userId || 'ADMIN';
      const { name, email, phone, password } = req.body;
      if (!name || !email || !password) {
        return res.status(400).json({ success: false, error: { message: 'Name, email, and password are required' } });
      }
      const manager = await AuthService.createSchoolManager(adminUserId, { name, email, phone, password });
      return res.status(201).json({ success: true, data: manager });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }

  static async changePassword(req: Request, res: Response) {
    try {
      const userId = (req as any).user?.userId || req.body.userId;
      const { currentPassword, newPassword } = req.body;
      if (!userId || !currentPassword || !newPassword) {
        return res.status(400).json({ success: false, error: { message: 'Current and new password are required' } });
      }
      const result = await AuthService.changePassword(userId, currentPassword, newPassword);
      return res.json({ success: true, data: result });
    } catch (error: any) {
      return res.status(400).json({ success: false, error: { message: error.message } });
    }
  }
}
