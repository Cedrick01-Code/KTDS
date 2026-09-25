"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationController = void 0;
const express_1 = require("express");
const notification_service_1 = require("../services/notification.service");
class NotificationController {
    static async list(req, res) {
        try {
            const { userId } = req.query;
            const notifications = await notification_service_1.NotificationService.listUserNotifications(userId);
            res.json({ success: true, data: notifications });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
    static async markRead(req, res) {
        try {
            const { id } = req.params;
            await notification_service_1.NotificationService.markAsRead(id);
            res.json({ success: true, message: 'Notification marked as read' });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
    static async markAllRead(req, res) {
        try {
            const { userId } = req.body;
            await notification_service_1.NotificationService.markAllAsRead(userId);
            res.json({ success: true, message: 'All notifications marked as read' });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
}
exports.NotificationController = NotificationController;
//# sourceMappingURL=notification.controller.js.map