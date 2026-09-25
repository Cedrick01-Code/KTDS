"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const prisma_1 = __importDefault(require("../utils/prisma"));
const client_1 = require("@prisma/client");
class AuthService {
    static async validateInvitation(referralCode, emailOrPhone, role) {
        const invitation = await prisma_1.default.userInvitation.findFirst({
            where: {
                referralCode,
                status: 'UNUSED',
                expiresAt: { gt: new Date() },
            },
        });
        if (!invitation) {
            throw new Error('Invalid or expired referral code');
        }
        if (invitation.role !== role) {
            throw new Error('Role mismatch for this invitation');
        }
        // Check if email or phone matches if provided in invitation
        if (invitation.email && invitation.email !== emailOrPhone) {
            throw new Error('Email does not match the invitation');
        }
        if (invitation.phone && invitation.phone !== emailOrPhone) {
            throw new Error('Phone does not match the invitation');
        }
        return invitation;
    }
    static async register(data) {
        const { emailOrPhone, password, role, referralCode } = data;
        const invitation = await this.validateInvitation(referralCode, emailOrPhone, role);
        const hashedPassword = await bcryptjs_1.default.hash(password, 12);
        const isEmail = emailOrPhone.includes('@');
        const user = await prisma_1.default.$transaction(async (tx) => {
            const newUser = await tx.user.create({
                data: {
                    schoolId: invitation.schoolId,
                    fullName: invitation.fullName,
                    email: isEmail ? emailOrPhone : null,
                    phone: !isEmail ? emailOrPhone : null,
                    password: hashedPassword,
                    role,
                },
            });
            await tx.userInvitation.update({
                where: { id: invitation.id },
                data: {
                    status: 'USED',
                    usedAt: new Date(),
                },
            });
            return newUser;
        });
        return user;
    }
    static async login(emailOrPhone, password) {
        const user = await prisma_1.default.user.findFirst({
            where: {
                OR: [
                    { email: emailOrPhone },
                    { phone: emailOrPhone },
                ],
            },
            include: { school: true },
        });
        if (!user || !(await bcryptjs_1.default.compare(password, user.password))) {
            throw new Error('Invalid credentials');
        }
        const token = jsonwebtoken_1.default.sign({ userId: user.id, role: user.role, schoolId: user.schoolId }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
        return { user, token };
    }
}
exports.AuthService = AuthService;
//# sourceMappingURL=auth.service.js.map