import prisma from '../utils/prisma';

export class SchoolService {
  static async setupSchool(data: {
    name: string;
    email?: string;
    phone?: string;
    address?: string;
    academicYearName: string;
    terms: string[];
  }) {
    return prisma.$transaction(async (tx) => {
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

  static async getSchoolInfo(id: string) {
    return prisma.school.findUnique({
      where: { id },
      include: {
        invitations: true,
      },
    });
  }
}
