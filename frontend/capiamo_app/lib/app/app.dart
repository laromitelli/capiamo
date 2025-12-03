import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/viewmodel/auth_viewmodel.dart';
import 'router.dart';
import 'theme.dart';

class CapiamoApp extends StatelessWidget {
  const CapiamoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return MaterialApp.router(
      title: 'Capiamo',
      theme: buildTheme(),
      routerConfig: buildRouter(authViewModel),
      debugShowCheckedModeBanner: false,
    );
  }
}
