import express, { Request, Response } from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import path from 'path';

import { connectDatabase } from './config/database';
import { AuthService } from './services/auth.service';

import authRoutes from './routes/auth.routes';
import invitationRoutes from './routes/invitation.routes';
import studentRoutes from './routes/student.routes';
import disciplineRoutes from './routes/discipline.routes';
import escalationRoutes from './routes/escalation.routes';
import notificationRoutes from './routes/notification.routes';
import whatsappRoutes from './routes/whatsapp.routes';
import auditRoutes from './routes/audit.routes';
import reportsRoutes from './routes/reports.routes';

dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

app.use(helmet({ crossOriginResourcePolicy: false }));
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());

// Serve PDF Letters and uploads statically
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

// Register Routes
app.use('/api/auth', authRoutes);
app.use('/api/invitations', invitationRoutes);
app.use('/api/students', studentRoutes);
app.use('/api/discipline', disciplineRoutes);
app.use('/api/escalations', escalationRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/whatsapp', whatsappRoutes);
app.use('/api/audit-logs', auditRoutes);
app.use('/api/reports', reportsRoutes);

app.get('/', (req: Request, res: Response) => {
  res.json({
    success: true,
    message: 'KAGEYO TSS DISCIPLINE SYSTEM (KTDS) API',
    version: '1.0.0',
    status: 'ONLINE',
  });
});

const startServer = async () => {
  await connectDatabase();
  await AuthService.seedAdminUser();

  app.listen(port, () => {
    console.log(`[server]: KTDS Backend is running at http://localhost:${port}`);
  });
};

startServer().catch((err) => {
  console.error('[server]: Failed to start backend server:', err);
});
