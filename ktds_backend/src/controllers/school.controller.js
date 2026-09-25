"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SchoolController = void 0;
const express_1 = require("express");
const school_service_1 = require("../services/school.service");
class SchoolController {
    static async setup(req, res) {
        try {
            const result = await school_service_1.SchoolService.setupSchool(req.body);
            res.status(201).json({
                success: true,
                data: result,
            });
        }
        catch (error) {
            res.status(400).json({
                success: false,
                message: error.message,
            });
        }
    }
    static async getInfo(req, res) {
        try {
            const { id } = req.params;
            const school = await school_service_1.SchoolService.getSchoolInfo(id);
            if (!school) {
                return res.status(404).json({
                    success: false,
                    message: 'School not found',
                });
            }
            res.json({
                success: true,
                data: school,
            });
        }
        catch (error) {
            res.status(500).json({
                success: false,
                message: error.message,
            });
        }
    }
}
exports.SchoolController = SchoolController;
//# sourceMappingURL=school.controller.js.map