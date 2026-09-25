"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const express_1 = require("express");
const auth_service_1 = require("../services/auth.service");
class AuthController {
    static async register(req, res) {
        try {
            const user = await auth_service_1.AuthService.register(req.body);
            res.status(201).json({
                success: true,
                data: user,
            });
        }
        catch (error) {
            res.status(400).json({
                success: false,
                message: error.message,
            });
        }
    }
    static async login(req, res) {
        try {
            const { emailOrPhone, password } = req.body;
            const data = await auth_service_1.AuthService.login(emailOrPhone, password);
            res.json({
                success: true,
                data,
            });
        }
        catch (error) {
            res.status(401).json({
                success: false,
                message: error.message,
            });
        }
    }
}
exports.AuthController = AuthController;
//# sourceMappingURL=auth.controller.js.map