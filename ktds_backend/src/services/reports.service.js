"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReportsService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
class ReportsService {
    static async getDashboardStats(schoolId) {
        const totalStudents = await prisma_1.default.student.count({
            where: { schoolId, status: 'ACTIVE' },
        });
        const pendingDeductions = await prisma_1.default.disciplineIncident.count({
            where: { schoolId, status: 'PENDING' },
        });
        const activeEscalations = await prisma_1.default.disciplineEscalation.count({
            where: { status: 'OPEN' }, // In real app, filter by school through student join
        });
        const recentIncidents = await prisma_1.default.disciplineIncident.findMany({
            where: { schoolId },
            include: {
                category: true,
            },
            orderBy: { createdAt: 'desc' },
            take: 5,
        });
        return {
            totalStudents,
            pendingDeductions,
            activeEscalations,
            recentIncidents,
        };
    }
    static async getStudentDisciplineReport(studentId) {
        return prisma_1.default.disciplineIncident.findMany({
            where: { studentId, status: 'APPROVED' },
            include: { category: true },
            orderBy: { date: 'desc' },
        });
    }
}
exports.ReportsService = ReportsService;
//# sourceMappingURL=reports.service.js.map