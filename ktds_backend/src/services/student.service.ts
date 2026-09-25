import prisma from '../utils/prisma';

export class StudentService {
  static async createStudent(data: {
    schoolId: string;
    studentId: string;
    fullName: string;
    dateOfBirth?: string;
    gender?: string;
    parentPhone?: string;
    parentWhatsApp?: string;
  }) {
    return prisma.student.create({
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

  static async listStudents(schoolId: string) {
    return prisma.student.findMany({
      where: { schoolId },
      orderBy: { fullName: 'asc' },
    });
  }

  static async getStudentProfile(id: string) {
    // In a real app, calculate current score here
    const student = await prisma.student.findUnique({
      where: { id },
    });

    if (!student) throw new Error('Student not found');

    // Mock score for now until engine is ready
    return {
      ...student,
      disciplineScore: 40,
      status: 'NORMAL',
    };
  }
}
