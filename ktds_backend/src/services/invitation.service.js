"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.InvitationService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
const client_1 = require("@prisma/client");
class InvitationService {
    static async createInvitation(data) {
        // Generate unique 5-digit referral code
        let referralCode;
        let isUnique = false;
        let attempts = 0;
        do {
            referralCode = Math.floor(10000 + Math.random() * 90000).toString();
            const existing = await prisma_1.default.userInvitation.findUnique({
                where: { referralCode },
            });
            if (!existing) {
                isUnique = true;
            }
            attempts++;
        } while (!isUnique && attempts < 10);
        if (!isUnique) {
            throw new Error('Could not generate a unique referral code. Please try again.');
        }
        const expiresAt = new Date();
        expiresAt.setDate(expiresAt.getDate() + 7); // Expires in 7 days
        const invitation = await prisma_1.default.userInvitation.create({
            data: {
                schoolId: data.schoolId,
                fullName: data.fullName,
                email: data.email,
                phone: data.phone,
                role: data.role,
                referralCode,
                createdBy: data.createdBy,
                expiresAt,
                status: 'UNUSED',
            },
        });
        return invitation;
    }
    static async listInvitations(schoolId) {
        return prisma_1.default.userInvitation.findMany({
            where: { schoolId },
            orderBy: { createdAt: 'desc' },
        });
    }
    static async revokeInvitation(id) {
        return prisma_1.default.userInvitation.update({
            where: { id },
            data: { status: 'REVOKED' },
        });
    }
}
exports.InvitationService = InvitationService;
//# sourceMappingURL=invitation.service.js.map