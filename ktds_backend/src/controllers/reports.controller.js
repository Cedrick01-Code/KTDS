"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReportsController = void 0;
const express_1 = require("express");
const reports_service_1 = require("../services/reports.service");
class ReportsController {
    static async getStats(req, res) {
        try {
            const { schoolId } = req.query;
            const stats = await reports_service_1.ReportsService.getDashboardStats(schoolId);
            res.json({ success: true, data: stats });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
    static async getStudentReport(req, res) {
        try {
            const { id } = req.params;
            const report = await reports_service_1.ReportsService.getStudentDisciplineReport(id);
            res.json({ success: true, data: report });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
}
exports.ReportsController = ReportsController;
//# sourceMappingURL=reports.controller.js.map