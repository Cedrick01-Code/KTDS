"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnnouncementController = void 0;
const express_1 = require("express");
const announcement_service_1 = require("../services/announcement.service");
class AnnouncementController {
    static async create(req, res) {
        try {
            const announcement = await announcement_service_1.AnnouncementService.createAnnouncement(req.body);
            res.status(201).json({ success: true, data: announcement });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
    static async list(req, res) {
        try {
            const { schoolId, audience } = req.query;
            const announcements = await announcement_service_1.AnnouncementService.listAnnouncements(schoolId, audience);
            res.json({ success: true, data: announcements });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
}
exports.AnnouncementController = AnnouncementController;
//# sourceMappingURL=announcement.controller.js.map