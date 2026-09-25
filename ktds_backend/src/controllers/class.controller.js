"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ClassController = void 0;
const express_1 = require("express");
const class_service_1 = require("../services/class.service");
class ClassController {
    static async create(req, res) {
        try {
            const newClass = await class_service_1.ClassService.createClass(req.body);
            res.status(201).json({ success: true, data: newClass });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
    static async list(req, res) {
        try {
            const { schoolId, academicYearId } = req.query;
            const classes = await class_service_1.ClassService.listClasses(schoolId, academicYearId);
            res.json({ success: true, data: classes });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
    static async assignTeacher(req, res) {
        try {
            const { id } = req.params;
            const { teacherId } = req.body;
            const updatedClass = await class_service_1.ClassService.assignClassTeacher(id, teacherId);
            res.json({ success: true, data: updatedClass });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
}
exports.ClassController = ClassController;
//# sourceMappingURL=class.controller.js.map