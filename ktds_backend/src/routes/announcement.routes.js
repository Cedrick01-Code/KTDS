"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const announcement_controller_1 = require("../controllers/announcement.controller");
const router = (0, express_1.Router)();
router.post('/', announcement_controller_1.AnnouncementController.create);
router.get('/', announcement_controller_1.AnnouncementController.list);
exports.default = router;
//# sourceMappingURL=announcement.routes.js.map