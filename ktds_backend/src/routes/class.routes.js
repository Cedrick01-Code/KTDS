"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const class_controller_1 = require("../controllers/class.controller");
const router = (0, express_1.Router)();
router.post('/', class_controller_1.ClassController.create);
router.get('/', class_controller_1.ClassController.list);
router.patch('/:id/teacher', class_controller_1.ClassController.assignTeacher);
exports.default = router;
//# sourceMappingURL=class.routes.js.map