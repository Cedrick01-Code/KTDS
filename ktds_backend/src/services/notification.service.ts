import prisma from '../utils/prisma';

export class NotificationService {
  static async createNotification(data: {
    schoolId: string;
    userId: string;
    title: string;
    message: string;
    type: string;
  }) {
    return prisma.notification.create({
      data,
    });
  }

  static async listUserNotifications(userId: string) {
    return prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  static async markAsRead(id: string) {
    return prisma.notification.update({
      where: { id },
      data: { isRead: true },
    });
  }

  static async markAllAsRead(userId: string) {
    return prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true },
    });
  }
}
