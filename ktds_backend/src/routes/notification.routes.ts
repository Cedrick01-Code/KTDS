import { Router } from 'express';
import { NotificationController } from '../controllers/notification.controller';

const router = Router();

router.get('/', NotificationController.listNotifications);
router.patch('/:id/read', NotificationController.markAsRead);

export default router;
