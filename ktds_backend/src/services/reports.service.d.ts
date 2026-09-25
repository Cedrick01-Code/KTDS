export declare class ReportsService {
    static getDashboardStats(schoolId: string): Promise<{
        totalStudents: number;
        pendingDeductions: number;
        activeEscalations: number;
        recentIncidents: ({
            category: {
                id: string;
                schoolId: string;
                status: string;
                createdAt: Date;
                updatedAt: Date;
                name: string;
                description: string | null;
                defaultPoints: number;
                severity: string;
            };
        } & {
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
        })[];
    }>;
    static getStudentDisciplineReport(studentId: string): Promise<({
        category: {
            id: string;
            schoolId: string;
            status: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            description: string | null;
            defaultPoints: number;
            severity: string;
        };
    } & {
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
    })[]>;
}
//# sourceMappingURL=reports.service.d.ts.map