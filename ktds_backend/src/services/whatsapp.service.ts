import axios from 'axios';
import { WhatsAppMessageModel, WhatsAppMessageType, WhatsAppStatus } from '../models/WhatsAppMessage';

export class WhatsAppService {
  static async sendMessage(data: {
    studentId: string;
    parentContactPhone: string;
    messageType: WhatsAppMessageType;
    messageText: string;
    documentUrl?: string;
  }) {
    const { studentId, parentContactPhone, messageType, messageText, documentUrl } = data;

    const record = await WhatsAppMessageModel.create({
      studentId,
      parentContactPhone,
      messageType,
      messageText,
      documentUrl,
      status: WhatsAppStatus.PENDING,
    });

    const apiUrl = process.env.WHATSAPP_API_URL;
    const token = process.env.WHATSAPP_ACCESS_TOKEN;
    const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID;

    if (!apiUrl || !token || !phoneNumberId) {
      console.warn('[whatsapp]: WhatsApp credentials not configured in environment. Marking as SENT (Simulated).');
      record.status = WhatsAppStatus.SENT;
      record.sentAt = new Date();
      await record.save();
      return record;
    }

    try {
      const response = await axios.post(
        `${apiUrl}/${phoneNumberId}/messages`,
        {
          messaging_product: 'whatsapp',
          to: parentContactPhone,
          type: documentUrl ? 'document' : 'text',
          text: documentUrl ? undefined : { body: messageText },
          document: documentUrl ? { link: documentUrl, caption: messageText } : undefined,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
        }
      );

      record.status = WhatsAppStatus.SENT;
      record.providerMessageId = response.data?.messages?.[0]?.id;
      record.sentAt = new Date();
      await record.save();
    } catch (error: any) {
      console.error('[whatsapp]: Error sending WhatsApp message:', error.response?.data || error.message);
      record.status = WhatsAppStatus.FAILED;
      record.errorMessage = error.response?.data?.error?.message || error.message;
      await record.save();
    }

    return record;
  }
}
