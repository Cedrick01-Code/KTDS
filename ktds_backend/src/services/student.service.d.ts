export declare class StudentService {
    static createStudent(data: {
        schoolId: string;
        studentId: string;
        fullName: string;
        dateOfBirth?: string;
        gender?: string;
        parentPhone?: string;
        parentWhatsApp?: string;
    }): Promise<{
        id: string;
        schoolId: string;
        fullName: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        studentId: string;
        dateOfBirth: Date | null;
        gender: string | null;
        parentPhone: string | null;
        parentWhatsApp: string | null;
        admissionDate: Date;
    }>;
    static listStudents(schoolId: string): Promise<{
        id: string;
        schoolId: string;
        fullName: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        studentId: string;
        dateOfBirth: Date | null;
        gender: string | null;
        parentPhone: string | null;
        parentWhatsApp: string | null;
        admissionDate: Date;
    }[]>;
    static getStudentProfile(id: string): Promise<{
        disciplineScore: number;
        status: string;
        id: string;
        schoolId: string;
        fullName: string;
        createdAt: Date;
        updatedAt: Date;
        studentId: string;
        dateOfBirth: Date | null;
        gender: string | null;
        parentPhone: string | null;
        parentWhatsApp: string | null;
        admissionDate: Date;
    }>;
}
//# sourceMappingURL=student.service.d.ts.map