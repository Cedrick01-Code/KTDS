"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.StudentController = void 0;
const express_1 = require("express");
const student_service_1 = require("../services/student.service");
class StudentController {
    static async create(req, res) {
        try {
            const student = await student_service_1.StudentService.createStudent(req.body);
            res.status(201).json({ success: true, data: student });
        }
        catch (error) {
            res.status(400).json({ success: false, message: error.message });
        }
    }
    static async list(req, res) {
        try {
            const { schoolId } = req.query;
            const students = await student_service_1.StudentService.listStudents(schoolId);
            res.json({ success: true, data: students });
        }
        catch (error) {
            res.status(500).json({ success: false, message: error.message });
        }
    }
    static async getProfile(req, res) {
        try {
            const { id } = req.params;
            const profile = await student_service_1.StudentService.getStudentProfile(id);
            res.json({ success: true, data: profile });
        }
        catch (error) {
            res.status(404).json({ success: false, message: error.message });
        }
    }
}
exports.StudentController = StudentController;
//# sourceMappingURL=student.controller.js.map