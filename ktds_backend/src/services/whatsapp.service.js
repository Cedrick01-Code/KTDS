"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WhatsAppService = void 0;
const axios_1 = __importDefault(require("axios"));
class WhatsAppService {
    static apiUrl = process.env.WHATSAPP_API_URL;
    static accessToken = process.env.WHATSAPP_ACCESS_TOKEN;
    static phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID;
    static async sendMessage(to, message) {
        console.log(`[WhatsApp] Sending message to ${to}: ${message}`);
        if (!this.apiUrl || !this.accessToken || !this.phoneNumberId) {
            console.warn('[WhatsApp] Service not configured. Logging to console instead.');
            return { success: true, status: 'SENT_MOCK' };
        }
        try {
            const response = await axios_1.default.post(`${this.apiUrl}/${this.phoneNumberId}/messages`, {
                messaging_product: 'whatsapp',
                to,
                type: 'text',
                text: { body: message },
            }, {
                headers: {
                    Authorization: `Bearer ${this.accessToken}`,
                },
            });
            return { success: true, data: response.data, status: 'SENT' };
        }
        catch (error) {
            console.error('[WhatsApp] Send failed:', error.response?.data || error.message);
            return { success: false, error: error.message, status: 'FAILED' };
        }
    }
    static async sendTemplate(to, templateName, components) {
        // Logic for sending template messages
        console.log(`[WhatsApp] Sending template ${templateName} to ${to}`);
        return { success: true, status: 'SENT_MOCK' };
    }
    static async sendDocument(to, documentUrl, filename) {
        // Logic for sending PDF documents (school letters)
        console.log(`[WhatsApp] Sending document ${filename} to ${to}`);
        return { success: true, status: 'SENT_MOCK' };
    }
}
exports.WhatsAppService = WhatsAppService;
//# sourceMappingURL=whatsapp.service.js.map