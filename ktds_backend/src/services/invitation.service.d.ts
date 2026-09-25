import { UserRole } from '@prisma/client';
export declare class InvitationService {
    static createInvitation(data: {
        schoolId: string;
        fullName: string;
        email?: string;
        phone?: string;
        role: UserRole;
        createdBy: string;
    }): Promise<{
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
    static listInvitations(schoolId: string): Promise<{
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
    }[]>;
    static revokeInvitation(id: string): Promise<{
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
}
//# sourceMappingURL=invitation.service.d.ts.map