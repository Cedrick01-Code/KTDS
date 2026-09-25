import { Router } from 'express';
import { DisciplineController } from '../controllers/discipline.controller';

const router = Router();

router.post('/incidents', DisciplineController.recordIncident);
router.get('/incidents', DisciplineController.listIncidents);
router.post('/deductions/:id/approve', DisciplineController.approveDeduction);
router.post('/deductions/:id/reject', DisciplineController.rejectDeduction);

export default router;
