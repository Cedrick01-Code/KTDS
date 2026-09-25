"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StudentService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
class StudentService {
    static async createStudent(data) {
        return prisma_1.default.student.create({
            data: {
                schoolId: data.schoolId,
                studentId: data.studentId,
                fullName: data.fullName,
                dateOfBirth: data.dateOfBirth ? new Date(data.dateOfBirth) : null,
                gender: data.gender,
                parentPhone: data.parentPhone,
                parentWhatsApp: data.parentWhatsApp,
            },
        });
    }
    static async listStudents(schoolId) {
        return prisma_1.default.student.findMany({
            where: { schoolId },
            orderBy: { fullName: 'asc' },
        });
    }
    static async getStudentProfile(id) {
        // In a real app, calculate current score here
        const student = await prisma_1.default.student.findUnique({
            where: { id },
        });
        if (!student)
            throw new Error('Student not found');
        // Mock score for now until engine is ready
        return {
            ...student,
            disciplineScore: 40,
            status: 'NORMAL',
        };
    }
}
exports.StudentService = StudentService;
//# sourceMappingURL=student.service.js.map