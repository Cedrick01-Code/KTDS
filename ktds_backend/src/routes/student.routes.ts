import { Router } from 'express';
import { StudentController } from '../controllers/student.controller';

const router = Router();

router.get('/', StudentController.listStudents);
router.post('/', StudentController.createStudent);
router.get('/:id', StudentController.getStudent);
router.post('/:id/remove', StudentController.removeStudent);

export default router;
