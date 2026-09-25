"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ClassService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
class ClassService {
    static async createClass(data) {
        return prisma_1.default.class.create({
            data: {
                schoolId: data.schoolId,
                academicYearId: data.academicYearId,
                name: data.name,
                classTeacherId: data.classTeacherId,
            },
        });
    }
    static async listClasses(schoolId, academicYearId) {
        return prisma_1.default.class.findMany({
            where: { schoolId, academicYearId },
            orderBy: { name: 'asc' },
        });
    }
    static async assignClassTeacher(classId, teacherId) {
        return prisma_1.default.class.update({
            where: { id: classId },
            data: { classTeacherId: teacherId },
        });
    }
}
exports.ClassService = ClassService;
//# sourceMappingURL=class.service.js.map