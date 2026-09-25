import { Router } from 'express';
import { SchoolController } from '../controllers/school.controller';

const router = Router();

router.post('/setup', SchoolController.setup);
router.get('/:id', SchoolController.getInfo);

export default router;
