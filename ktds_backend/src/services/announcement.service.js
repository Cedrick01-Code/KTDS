"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AnnouncementService = void 0;
const prisma_1 = __importDefault(require("../utils/prisma"));
class AnnouncementService {
    static async createAnnouncement(data) {
        return prisma_1.default.announcement.create({
            data,
        });
    }
    static async listAnnouncements(schoolId, audience) {
        const where = { schoolId };
        if (audience && audience !== 'ALL') {
            where.OR = [
                { audience: 'ALL' },
                { audience: audience }
            ];
        }
        return prisma_1.default.announcement.findMany({
            where,
            orderBy: { createdAt: 'desc' },
        });
    }
}
exports.AnnouncementService = AnnouncementService;
//# sourceMappingURL=announcement.service.js.map