import { UserRole } from '@prisma/client';
export declare class DisciplineService {
    static submitIncident(data: {
        schoolId: string;
        studentId: string;
        academicYearId: string;
        termId: string;
        categoryId: string;
        description: string;
        recordedById: string;
        userRole: UserRole;
        points?: number;
    }): Promise<{
        id: string;
        schoolId: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        academicYearId: string;
        studentId: string;
        description: string;
        termId: string;
        points: number;
        recordedById: string;
        date: Date;
        location: string | null;
        categoryId: string;
    }>;
    static approveDeduction(incidentId: string, approvedById: string, status: 'APPROVED' | 'REJECTED', reason?: string): Promise<{
        id: string;
        schoolId: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        academicYearId: string;
        studentId: string;
        description: string;
        termId: string;
        points: number;
        recordedById: string;
        date: Date;
        location: string | null;
        categoryId: string;
    }>;
    private static checkThreshold;
    static getStudentScore(studentId: string, academicYearId: string, termId: string): Promise<number>;
}
//# sourceMappingURL=discipline.service.d.ts.map