import { UserRole } from '@prisma/client';
export declare class AuthService {
    static validateInvitation(referralCode: string, emailOrPhone: string, role: UserRole): Promise<{
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
    }>;
    static register(data: any): Promise<{
        id: string;
        schoolId: string;
        fullName: string;
        email: string | null;
        phone: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        status: string;
        createdAt: Date;
        updatedAt: Date;
        password: string;
    }>;
    static login(emailOrPhone: string, password: string): Promise<{
        user: {
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
        } & {
            id: string;
            schoolId: string;
            fullName: string;
            email: string | null;
            phone: string | null;
            role: import(".prisma/client").$Enums.UserRole;
            status: string;
            createdAt: Date;
            updatedAt: Date;
            password: string;
        };
        token: never;
    }>;
}
//# sourceMappingURL=auth.service.d.ts.map