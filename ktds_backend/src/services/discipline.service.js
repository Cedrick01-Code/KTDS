"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.DisciplineService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
const client_1 = require("@prisma/client");
class DisciplineService {
    static async submitIncident(data) {
        const category = await prisma_1.default.disciplineCategory.findUnique({
            where: { id: data.categoryId },
        });
        if (!category)
            throw new Error('Category not found');
        const points = data.points ?? category.defaultPoints;
        // Determine status based on role
        const isDirect = [client_1.UserRole.DOD, client_1.UserRole.PATRON, client_1.UserRole.MATRON, client_1.UserRole.ADMIN].includes(data.userRole);
        const status = isDirect ? 'APPROVED' : 'PENDING';
        const incident = await prisma_1.default.disciplineIncident.create({
            data: {
                schoolId: data.schoolId,
                studentId: data.studentId,
                academicYearId: data.academicYearId,
                termId: data.termId,
                categoryId: data.categoryId,
                description: data.description,
                points,
                recordedById: data.recordedById,
                status,
            },
        });
        if (isDirect) {
            await this.checkThreshold(data.studentId, data.academicYearId, data.termId);
        }
        return incident;
    }
    static async approveDeduction(incidentId, approvedById, status, reason) {
        return prisma_1.default.$transaction(async (tx) => {
            const incident = await tx.disciplineIncident.update({
                where: { id: incidentId },
                data: { status },
            });
            await tx.deductionApproval.create({
                data: {
                    incidentId,
                    approvedById,
                    status,
                    reason,
                },
            });
            if (status === 'APPROVED') {
                await this.checkThreshold(incident.studentId, incident.academicYearId, incident.termId);
            }
            return incident;
        });
    }
    static async checkThreshold(studentId, academicYearId, termId) {
        const totalDeductions = await prisma_1.default.disciplineIncident.aggregate({
            where: {
                studentId,
                academicYearId,
                termId,
                status: 'APPROVED',
            },
            _sum: {
                points: true,
            },
        });
        const totalPoints = totalDeductions._sum.points ?? 0;
        const currentScore = 40 - totalPoints;
        if (currentScore <= 18) {
            // Create escalation if it doesn't exist for this term
            const existing = await prisma_1.default.disciplineEscalation.findFirst({
                where: { studentId, academicYearId, termId, status: 'OPEN' },
            });
            if (!existing) {
                await prisma_1.default.disciplineEscalation.create({
                    data: {
                        studentId,
                        academicYearId,
                        termId,
                        score: currentScore,
                    },
                });
                // In a real app, send notifications here
            }
        }
    }
    static async getStudentScore(studentId, academicYearId, termId) {
        const totalDeductions = await prisma_1.default.disciplineIncident.aggregate({
            where: {
                studentId,
                academicYearId,
                termId,
                status: 'APPROVED',
            },
            _sum: {
                points: true,
            },
        });
        const totalPoints = totalDeductions._sum.points ?? 0;
        return 40 - totalPoints;
    }
}
exports.DisciplineService = DisciplineService;
//# sourceMappingURL=discipline.service.js.map