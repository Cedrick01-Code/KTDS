import { Router } from 'express';
import { ClassController } from '../controllers/class.controller';

const router = Router();

router.post('/', ClassController.create);
router.get('/', ClassController.list);
router.patch('/:id/teacher', ClassController.assignTeacher);

export default router;
