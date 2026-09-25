"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const discipline_controller_1 = require("../controllers/discipline.controller");
const router = (0, express_1.Router)();
router.post('/incidents', discipline_controller_1.DisciplineController.submit);
router.post('/incidents/:id/approve', discipline_controller_1.DisciplineController.approve);
router.get('/score', discipline_controller_1.DisciplineController.getScore);
exports.default = router;
//# sourceMappingURL=discipline.routes.js.map