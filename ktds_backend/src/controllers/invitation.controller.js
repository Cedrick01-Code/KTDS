"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.InvitationController = void 0;
const express_1 = require("express");
const invitation_service_1 = require("../services/invitation.service");
class InvitationController {
    static async create(req, res) {
        try {
            // In a real app, schoolId and createdBy would come from the auth middleware
            const invitation = await invitation_service_1.InvitationService.createInvitation(req.body);
            res.status(201).json({
                success: true,
                data: invitation,
            });
        }
        catch (error) {
            res.status(400).json({
                success: false,
                message: error.message,
            });
        }
    }
    static async list(req, res) {
        try {
            const { schoolId } = req.query;
            const invitations = await invitation_service_1.InvitationService.listInvitations(schoolId);
            res.json({
                success: true,
                data: invitations,
            });
        }
        catch (error) {
            res.status(500).json({
                success: false,
                message: error.message,
            });
        }
    }
    static async revoke(req, res) {
        try {
            const { id } = req.params;
            await invitation_service_1.InvitationService.revokeInvitation(id);
            res.json({
                success: true,
                message: 'Invitation revoked successfully',
            });
        }
        catch (error) {
            res.status(400).json({
                success: false,
                message: error.message,
            });
        }
    }
}
exports.InvitationController = InvitationController;
//# sourceMappingURL=invitation.controller.js.map