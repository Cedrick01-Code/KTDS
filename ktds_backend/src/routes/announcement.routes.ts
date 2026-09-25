import { Router } from 'express';
import { AnnouncementController } from '../controllers/announcement.controller';

const router = Router();

router.post('/', AnnouncementController.create);
router.get('/', AnnouncementController.list);

export default router;
