"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const invitation_controller_1 = require("../controllers/invitation.controller");
const router = (0, express_1.Router)();
router.post('/', invitation_controller_1.InvitationController.create);
router.get('/', invitation_controller_1.InvitationController.list);
router.patch('/:id/revoke', invitation_controller_1.InvitationController.revoke);
exports.default = router;
//# sourceMappingURL=invitation.routes.js.map