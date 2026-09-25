"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const reports_controller_1 = require("../controllers/reports.controller");
const router = (0, express_1.Router)();
router.get('/stats', reports_controller_1.ReportsController.getStats);
router.get('/student/:id', reports_controller_1.ReportsController.getStudentReport);
exports.default = router;
//# sourceMappingURL=reports.routes.js.map