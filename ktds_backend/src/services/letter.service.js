"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LetterService = void 0;
const pdfkit_1 = __importDefault(require("pdfkit"));
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
class LetterService {
    static async generateSchoolLetter(data) {
        return new Promise((resolve, reject) => {
            const doc = new pdfkit_1.default({ margin: 50 });
            const filename = `letter_${data.studentId}_${Date.now()}.pdf`;
            const filePath = path_1.default.join(__dirname, '../../temp', filename);
            // Ensure temp directory exists
            if (!fs_1.default.existsSync(path_1.default.join(__dirname, '../../temp'))) {
                fs_1.default.mkdirSync(path_1.default.join(__dirname, '../../temp'));
            }
            const stream = fs_1.default.createWriteStream(filePath);
            doc.pipe(stream);
            // Header
            doc.fontSize(20).text('KAGEYO TSS', { align: 'center' });
            doc.fontSize(14).text('DISCIPLINE SYSTEM (KTDS)', { align: 'center' });
            doc.moveDown();
            // Body
            doc.fontSize(12).text(`Date: ${new Date().toLocaleDateString()}`);
            doc.moveDown();
            doc.text(`To: ${data.parentName}`);
            doc.moveDown();
            doc.fontSize(14).text('SUBJECT: OFFICIAL DISCIPLINE NOTIFICATION', { underline: true });
            doc.moveDown();
            doc.fontSize(12).text(`This is to inform you about the current discipline status of your child:`);
            doc.text(`Name: ${data.studentName}`);
            doc.text(`Student ID: ${data.studentId}`);
            doc.text(`Class: ${data.className}`);
            doc.moveDown();
            doc.fontSize(16).fillColor('red').text(`Current Score: ${data.score} / 40`);
            doc.fillColor('black');
            doc.moveDown();
            if (data.managerMessage) {
                doc.text(`School Manager Message:`);
                doc.text(data.managerMessage, { oblique: true });
                doc.moveDown();
            }
            doc.text('Please visit the school portal or contact the administration for further details.');
            doc.moveDown(2);
            doc.text('__________________________');
            doc.text('School Manager Signature');
            doc.end();
            stream.on('finish', () => resolve(filePath));
            stream.on('error', reject);
        });
    }
}
exports.LetterService = LetterService;
//# sourceMappingURL=letter.service.js.map