import prisma from '../utils/prisma';

export class ReportsService {
  static async getDashboardStats(schoolId: string) {
    const totalStudents = await prisma.student.count({
      where: { schoolId, status: 'ACTIVE' },
    });

    const pendingDeductions = await prisma.disciplineIncident.count({
      where: { schoolId, status: 'PENDING' },
    });

    const activeEscalations = await prisma.disciplineEscalation.count({
      where: { status: 'OPEN' }, // In real app, filter by school through student join
    });

    const recentIncidents = await prisma.disciplineIncident.findMany({
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

  static async getStudentDisciplineReport(studentId: string) {
    return prisma.disciplineIncident.findMany({
      where: { studentId, status: 'APPROVED' },
      include: { category: true },
      orderBy: { date: 'desc' },
    });
  }
}
