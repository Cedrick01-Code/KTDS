import { Router } from 'express';
import { InvitationController } from '../controllers/invitation.controller';

const router = Router();

router.post('/', InvitationController.createInvitation);
router.get('/', InvitationController.listInvitations);
router.patch('/:id/revoke', InvitationController.revokeInvitation);

export default router;
