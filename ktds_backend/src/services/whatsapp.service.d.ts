export declare class WhatsAppService {
    private static readonly apiUrl;
    private static readonly accessToken;
    private static readonly phoneNumberId;
    static sendMessage(to: string, message: string): Promise<{
        success: boolean;
        status: string;
        data?: never;
        error?: never;
    } | {
        success: boolean;
        data: any;
        status: string;
        error?: never;
    } | {
        success: boolean;
        error: any;
        status: string;
        data?: never;
    }>;
    static sendTemplate(to: string, templateName: string, components: any[]): Promise<{
        success: boolean;
        status: string;
    }>;
    static sendDocument(to: string, documentUrl: string, filename: string): Promise<{
        success: boolean;
        status: string;
    }>;
}
//# sourceMappingURL=whatsapp.service.d.ts.map