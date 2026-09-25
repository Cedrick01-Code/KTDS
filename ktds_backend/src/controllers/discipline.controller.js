"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DisciplineController = void 0;
const express_1 = require("express");
const discipline_service_1 = require("../services/discipline.service");
class DisciplineController {
    static async submit(req, res) {
        try {
            // Role would come from auth middleware in real app
            const incident = await discipline_service_1.DisciplineService.submitIncident(req.body);
            res.status(201).json({ success: true, data: incident });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
    static async approve(req, res) {
        try {
            const { id } = req.params;
            const { approvedById, status, reason } = req.body;
            const incident = await discipline_service_1.DisciplineService.approveDeduction(id, approvedById, status, reason);
            res.json({ success: true, data: incident });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
    static async getScore(req, res) {
        try {
            const { studentId, academicYearId, termId } = req.query;
            const score = await discipline_service_1.DisciplineService.getStudentScore(studentId, academicYearId, termId);
            res.json({ success: true, data: { score } });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
}
exports.DisciplineController = DisciplineController;
//# sourceMappingURL=discipline.controller.js.map