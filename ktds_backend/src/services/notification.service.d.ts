export declare class NotificationService {
    static createNotification(data: {
        schoolId: string;
        userId: string;
        title: string;
        message: string;
        type: string;
    }): Promise<{
        id: string;
        schoolId: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        title: string;
        message: string;
        type: string;
        isRead: boolean;
    }>;
    static listUserNotifications(userId: string): Promise<{
        id: string;
        schoolId: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        title: string;
        message: string;
        type: string;
        isRead: boolean;
    }[]>;
    static markAsRead(id: string): Promise<{
        id: string;
        schoolId: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        title: string;
        message: string;
        type: string;
        isRead: boolean;
    }>;
    static markAllAsRead(userId: string): Promise<import(".prisma/client").Prisma.BatchPayload>;
}
//# sourceMappingURL=notification.service.d.ts.map