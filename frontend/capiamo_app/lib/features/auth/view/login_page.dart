import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: authVM.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fake Instagram gradient text
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                          Color(0xFF515BD4),
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Capiamo',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text(
                      'Continue with Facebook',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDD2A7B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      final vm =
                          context.read<AuthViewModel>();
                      await vm.loginWithFacebook();
                      if (vm.isLoggedIn && context.mounted) {
                        Navigator.of(context)
                            .pushReplacementNamed('/home');
                      }
                    },
                  ),
                  if (authVM.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      authVM.error!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
