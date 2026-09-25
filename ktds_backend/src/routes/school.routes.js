"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const school_controller_1 = require("../controllers/school.controller");
const router = (0, express_1.Router)();
router.post('/setup', school_controller_1.SchoolController.setup);
router.get('/:id', school_controller_1.SchoolController.getInfo);
exports.default = router;
//# sourceMappingURL=school.routes.js.map