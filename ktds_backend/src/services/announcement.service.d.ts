export declare class AnnouncementService {
    static createAnnouncement(data: {
        schoolId: string;
        title: string;
        message: string;
        audience: string;
    }): Promise<{
        id: string;
        schoolId: string;
        createdAt: Date;
        updatedAt: Date;
        audience: string;
        title: string;
        message: string;
    }>;
    static listAnnouncements(schoolId: string, audience?: string): Promise<{
        id: string;
        schoolId: string;
        createdAt: Date;
        updatedAt: Date;
        audience: string;
        title: string;
        message: string;
    }[]>;
}
//# sourceMappingURL=announcement.service.d.ts.map