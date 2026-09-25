import { Router } from 'express';
import { EscalationController } from '../controllers/escalation.controller';

const router = Router();

router.get('/', EscalationController.listEscalationCases);
router.get('/:id', EscalationController.getEscalationCase);

export default router;
