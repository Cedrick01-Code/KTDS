"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importStar(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const morgan_1 = __importDefault(require("morgan"));
const auth_routes_1 = __importDefault(require("./routes/auth.routes"));
const invitation_routes_1 = __importDefault(require("./routes/invitation.routes"));
const school_routes_1 = __importDefault(require("./routes/school.routes"));
const student_routes_1 = __importDefault(require("./routes/student.routes"));
const class_routes_1 = __importDefault(require("./routes/class.routes"));
const discipline_routes_1 = __importDefault(require("./routes/discipline.routes"));
const notification_routes_1 = __importDefault(require("./routes/notification.routes"));
const announcement_routes_1 = __importDefault(require("./routes/announcement.routes"));
const reports_routes_1 = __importDefault(require("./routes/reports.routes"));
dotenv_1.default.config();
const app = (0, express_1.default)();
const port = process.env.PORT || 3000;
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)());
app.use((0, morgan_1.default)('dev'));
app.use(express_1.default.json());
app.use('/api/auth', auth_routes_1.default);
app.use('/api/invitations', invitation_routes_1.default);
app.use('/api/schools', school_routes_1.default);
app.use('/api/students', student_routes_1.default);
app.use('/api/classes', class_routes_1.default);
app.use('/api/discipline', discipline_routes_1.default);
app.use('/api/notifications', notification_routes_1.default);
app.use('/api/announcements', announcement_routes_1.default);
app.use('/api/reports', reports_routes_1.default);
app.get('/', (req, res) => {
    res.json({
        success: true,
        message: 'KTDS API is running',
    });
});
app.listen(port, () => {
    console.log(`[server]: Server is running at http://localhost:${port}`);
});
//# sourceMappingURL=index.js.map