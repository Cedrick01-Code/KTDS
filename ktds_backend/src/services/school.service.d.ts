export declare class SchoolService {
    static setupSchool(data: {
        name: string;
        email?: string;
        phone?: string;
        address?: string;
        academicYearName: string;
        terms: string[];
    }): Promise<{
        school: {
            id: string;
            email: string | null;
            phone: string | null;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            logoUrl: string | null;
            address: string | null;
        };
        academicYear: {
            id: string;
            schoolId: string;
            status: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
        };
    }>;
    static getSchoolInfo(id: string): Promise<({
        invitations: {
            id: string;
            schoolId: string;
            fullName: string;
            email: string | null;
            phone: string | null;
            role: import(".prisma/client").$Enums.UserRole;
            referralCode: string;
            status: import(".prisma/client").$Enums.InvitationStatus;
            createdBy: string;
            expiresAt: Date;
            usedAt: Date | null;
            createdAt: Date;
            updatedAt: Date;
        }[];
    } & {
        id: string;
        email: string | null;
        phone: string | null;
        createdAt: Date;
        updatedAt: Date;
        name: string;
        logoUrl: string | null;
        address: string | null;
    }) | null>;
}
//# sourceMappingURL=school.service.d.ts.map