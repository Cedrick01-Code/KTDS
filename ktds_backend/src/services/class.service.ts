import prisma from '../utils/prisma';

export class ClassService {
  static async createClass(data: {
    schoolId: string;
    academicYearId: string;
    name: string;
    classTeacherId?: string;
  }) {
    return prisma.class.create({
      data: {
        schoolId: data.schoolId,
        academicYearId: data.academicYearId,
        name: data.name,
        classTeacherId: data.classTeacherId || null,
      },
    });
  }

  static async listClasses(schoolId: string, academicYearId: string) {
    return prisma.class.findMany({
      where: { schoolId, academicYearId },
      orderBy: { name: 'asc' },
    });
  }

  static async assignClassTeacher(classId: string, teacherId: string) {
    return prisma.class.update({
      where: { id: classId },
      data: { classTeacherId: teacherId },
    });
  }
}
