import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/message.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/home_viewmodel.dart';
import 'map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final homeViewModel = context.read<HomeViewModel>();
    homeViewModel.loadCurrentLocation().then((_) {
      homeViewModel.loadNearbyMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Capiamo',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          // ----- USER AVATAR BUTTON -----
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: user != null && user.profilePictureUri != null
                  ? CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(user.profilePictureUri!),
                    )
                  : const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
            ),
          ),

          // ----- LOGOUT MORE MENU -----
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) async {
              if (value == 'logout') {
                await authViewModel.logout();
                if (mounted) context.go('/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: MapWidget(
              messages: homeViewModel.messages,
              isLoading: homeViewModel.isLoading,
              onMarkerTap: _showMessageDialog,
            ),
          ),
          if (homeViewModel.error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                homeViewModel.error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/message/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMessageDialog(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Situa'),
        content: Text(message.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
