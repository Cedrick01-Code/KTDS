export declare class ClassService {
    static createClass(data: {
        schoolId: string;
        academicYearId: string;
        name: string;
        classTeacherId?: string;
    }): Promise<{
        id: string;
        schoolId: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        name: string;
        academicYearId: string;
        classTeacherId: string | null;
    }>;
    static listClasses(schoolId: string, academicYearId: string): Promise<{
        id: string;
        schoolId: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        name: string;
        academicYearId: string;
        classTeacherId: string | null;
    }[]>;
    static assignClassTeacher(classId: string, teacherId: string): Promise<{
        id: string;
        schoolId: string;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        name: string;
        academicYearId: string;
        classTeacherId: string | null;
    }>;
}
//# sourceMappingURL=class.service.d.ts.map