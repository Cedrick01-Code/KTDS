"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuditService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
const client_1 = require("@prisma/client");
class AuditService {
    static async logAction(data) {
        return prisma_1.default.auditLog.create({
            data: {
                schoolId: data.schoolId,
                userId: data.userId,
                userRole: data.userRole,
                action: data.action,
                entityType: data.entityType,
                entityId: data.entityId,
                previousValue: data.previousValue,
                newValue: data.newValue,
                reason: data.reason,
            },
        });
    }
    static async getLogs(schoolId) {
        return prisma_1.default.auditLog.findMany({
            where: { schoolId },
            orderBy: { timestamp: 'desc' },
            take: 100,
        });
    }
}
exports.AuditService = AuditService;
//# sourceMappingURL=audit.service.js.map