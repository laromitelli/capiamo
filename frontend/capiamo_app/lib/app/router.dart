import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/view/login_page.dart';
import '../features/auth/viewmodel/auth_viewmodel.dart';
import '../features/home/view/home_page.dart';
import '../features/message_form/view/message_form_page.dart';
import '../features/profile/view/profile_page.dart';

GoRouter buildRouter(AuthViewModel authViewModel) {
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: authViewModel,
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = authViewModel.isLoggedIn;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/message/new',
        builder: (context, state) => const MessageFormPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
