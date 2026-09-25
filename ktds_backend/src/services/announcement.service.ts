import prisma from '../utils/prisma';

export class AnnouncementService {
  static async createAnnouncement(data: {
    schoolId: string;
    title: string;
    message: string;
    audience: string;
  }) {
    return prisma.announcement.create({
      data,
    });
  }

  static async listAnnouncements(schoolId: string, audience?: string) {
    const where: any = { schoolId };
    if (audience && audience !== 'ALL') {
      where.OR = [
        { audience: 'ALL' },
        { audience: audience }
      ];
    }
    return prisma.announcement.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });
  }
}
