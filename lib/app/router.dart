import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/splash_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/auth/presentation/forced_password_change_page.dart';
import '../features/portal/presentation/portal_page.dart';
import '../features/discipline/presentation/record_incident_page.dart';
import '../features/discipline/presentation/manager_case_page.dart';
import '../features/notifications/presentation/notification_center_page.dart';
import '../features/announcements/presentation/announcements_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forced-password-change',
        builder: (context, state) => const ForcedPasswordChangePage(),
      ),
      GoRoute(
        path: '/record-incident',
        builder: (context, state) => const RecordIncidentPage(),
      ),
      GoRoute(
        path: '/case/:id',
        builder: (context, state) => ManagerCasePage(studentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationCenterPage(),
      ),
      GoRoute(
        path: '/announcements',
        builder: (context, state) => const AnnouncementsPage(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const PortalPage(role: PortalRole.admin),
      ),
      GoRoute(
        path: '/manager/dashboard',
        builder: (context, state) => const PortalPage(role: PortalRole.manager),
      ),
      GoRoute(
        path: '/staff/dashboard',
        builder: (context, state) => const PortalPage(role: PortalRole.staff),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
});
