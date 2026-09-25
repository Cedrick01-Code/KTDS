import { Router } from 'express';
import { WhatsAppController } from '../controllers/whatsapp.controller';

const router = Router();

router.get('/messages', WhatsAppController.listMessages);

export default router;
