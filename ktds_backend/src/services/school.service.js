"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SchoolService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
class SchoolService {
    static async setupSchool(data) {
        return prisma_1.default.$transaction(async (tx) => {
            // 1. Create School
            const school = await tx.school.create({
                data: {
                    name: data.name,
                    email: data.email,
                    phone: data.phone,
                    address: data.address,
                },
            });
            // 2. Create Academic Year
            const academicYear = await tx.academicYear.create({
                data: {
                    schoolId: school.id,
                    name: data.academicYearName,
                    status: 'ACTIVE',
                },
            });
            // 3. Create Terms
            for (const termName of data.terms) {
                await tx.term.create({
                    data: {
                        academicYearId: academicYear.id,
                        name: termName,
                        status: 'ACTIVE',
                    },
                });
            }
            return { school, academicYear };
        });
    }
    static async getSchoolInfo(id) {
        return prisma_1.default.school.findUnique({
            where: { id },
            include: {
                invitations: true,
            },
        });
    }
}
exports.SchoolService = SchoolService;
//# sourceMappingURL=school.service.js.map