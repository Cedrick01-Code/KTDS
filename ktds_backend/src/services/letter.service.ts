import PDFDocument from 'pdfkit';
import fs from 'fs';
import path from 'path';

export class PdfService {
  private static ensureUploadDirectoryExists(): string {
    const dir = path.join(process.cwd(), 'uploads', 'letters');
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    return dir;
  }

  static async generate18Over40Letter(data: {
    studentId: string;
    studentName: string;
    className: string;
    currentScore: number;
    parentName?: string;
    incidents?: Array<{ category: string; points: number; description: string; date: string }>;
  }): Promise<string> {
    const dir = this.ensureUploadDirectoryExists();
    const filename = `KTDS_18-40_${data.studentId}_${Date.now()}.pdf`;
    const filePath = path.join(dir, filename);

    return new Promise((resolve, reject) => {
      const doc = new PDFDocument({ margin: 50 });
      const stream = fs.createWriteStream(filePath);

      doc.pipe(stream);

      // School Header
      doc.fillColor('#3078CB').fontSize(22).text('KAGEYO TSS', { align: 'center' });
      doc.fillColor('#172033').fontSize(14).text('DISCIPLINE MANAGEMENT SYSTEM (KTDS)', { align: 'center' });
      doc.moveDown(0.5);
      doc.strokeColor('#3078CB').lineWidth(2).moveTo(50, doc.y).lineTo(550, doc.y).stroke();
      doc.moveDown(1.5);

      // Title
      doc.fillColor('#D64545').fontSize(16).text('OFFICIAL DISCIPLINE THRESHOLD NOTICE (18/40)', { align: 'center' });
      doc.moveDown(1);

      // Metadata
      doc.fillColor('#172033').fontSize(11);
      doc.text(`Date: ${new Date().toLocaleDateString()}`);
      doc.text(`Student Name: ${data.studentName}`);
      doc.text(`Student ID: ${data.studentId}`);
      doc.text(`Class: ${data.className}`);
      doc.text(`Current Discipline Score: ${data.currentScore} / 40`);
      doc.moveDown(1);

      // Notice Body
      doc.fontSize(10).text(
        `Dear Parent / Guardian (${data.parentName || 'Parent'}),\n\n` +
          `This letter serves as official notification from Kageyo TSS Management that your child ${data.studentName} ` +
          `has crossed the critical discipline threshold and currently holds a score of ${data.currentScore}/40.\n\n` +
          `Under Kageyo TSS disciplinary regulations, students reaching or dropping below 18/40 require immediate ` +
          `review by the School Disciplinary Committee and School Management.`
      );

      doc.moveDown(1.5);
      doc.fontSize(12).fillColor('#3078CB').text('Recent Disciplinary Actions:');
      doc.moveDown(0.5);

      if (data.incidents && data.incidents.length > 0) {
        data.incidents.forEach((inc) => {
          doc
            .fontSize(10)
            .fillColor('#172033')
            .text(`• [-${inc.points} pts] ${inc.category}: ${inc.description} (${inc.date})`);
        });
      } else {
        doc.fontSize(10).fillColor('#172033').text('• Accumulated discipline point deductions during the term.');
      }

      doc.moveDown(2);
      doc.text('Please contact Kageyo TSS Administration at your earliest convenience.');

      doc.moveDown(3);
      doc.text('______________________________', { align: 'right' });
      doc.text('School Management / DOD Office', { align: 'right' });

      doc.end();

      stream.on('finish', () => resolve(`/uploads/letters/${filename}`));
      stream.on('error', (err) => reject(err));
    });
  }

  static async generateRemovalLetter(data: {
    studentId: string;
    studentName: string;
    className: string;
    reason: string;
    category: string;
    removedByName: string;
  }): Promise<string> {
    const dir = this.ensureUploadDirectoryExists();
    const filename = `KTDS_REMOVAL_${data.studentId}_${Date.now()}.pdf`;
    const filePath = path.join(dir, filename);

    return new Promise((resolve, reject) => {
      const doc = new PDFDocument({ margin: 50 });
      const stream = fs.createWriteStream(filePath);

      doc.pipe(stream);

      // Header
      doc.fillColor('#3078CB').fontSize(22).text('KAGEYO TSS', { align: 'center' });
      doc.fillColor('#172033').fontSize(14).text('OFFICE OF THE SCHOOL MANAGER', { align: 'center' });
      doc.moveDown(0.5);
      doc.strokeColor('#D64545').lineWidth(2).moveTo(50, doc.y).lineTo(550, doc.y).stroke();
      doc.moveDown(1.5);

      // Title
      doc.fillColor('#D64545').fontSize(16).text('OFFICIAL DISCIPLINARY REMOVAL DECISION', { align: 'center' });
      doc.moveDown(1);

      doc.fillColor('#172033').fontSize(11);
      doc.text(`Date: ${new Date().toLocaleDateString()}`);
      doc.text(`Student Name: ${data.studentName}`);
      doc.text(`Student ID: ${data.studentId}`);
      doc.text(`Class: ${data.className}`);
      doc.moveDown(1);

      doc.fontSize(10).text(
        `Dear Parent / Guardian,\n\n` +
          `Following a comprehensive review of disciplinary records and authorized administrative proceedings, ` +
          `this official communication confirms that ${data.studentName} has been officially REMOVED from Kageyo TSS.\n\n` +
          `Category of Violation: ${data.category}\n` +
          `Detailed Reason: ${data.reason}\n\n` +
          `All official school access and student privileges have been suspended effective immediately in accordance ` +
          `with Kageyo TSS regulations.`
      );

      doc.moveDown(3);
      doc.text('______________________________', { align: 'right' });
      doc.text(`${data.removedByName}`, { align: 'right' });
      doc.text('School Manager, Kageyo TSS', { align: 'right' });

      doc.end();

      stream.on('finish', () => resolve(`/uploads/letters/${filename}`));
      stream.on('error', (err) => reject(err));
    });
  }
}
