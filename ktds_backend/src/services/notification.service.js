"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
class NotificationService {
    static async createNotification(data) {
        return prisma_1.default.notification.create({
            data,
        });
    }
    static async listUserNotifications(userId) {
        return prisma_1.default.notification.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }
    static async markAsRead(id) {
        return prisma_1.default.notification.update({
            where: { id },
            data: { isRead: true },
        });
    }
    static async markAllAsRead(userId) {
        return prisma_1.default.notification.updateMany({
            where: { userId, isRead: false },
            data: { isRead: true },
        });
    }
}
exports.NotificationService = NotificationService;
//# sourceMappingURL=notification.service.js.map