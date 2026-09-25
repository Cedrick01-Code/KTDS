import { Router } from 'express';
import { ReportsController } from '../controllers/reports.controller';

const router = Router();

router.get('/discipline', ReportsController.getDisciplineSummary);
router.get('/18-40', ReportsController.getThresholdReport);
router.get('/removals', ReportsController.getRemovalsReport);

export default router;
