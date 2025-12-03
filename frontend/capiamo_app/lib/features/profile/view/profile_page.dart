import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayedNameController;
  late TextEditingController _profileUriController;
  bool _hidePic = false;

  @override
  void initState() {
    super.initState();
    final authViewModel = context.read<AuthViewModel>();
    final profileViewModel = context.read<ProfileViewModel>();

    final user = authViewModel.currentUser;
    if (user != null) {
      profileViewModel.setUser(user);
      _displayedNameController =
          TextEditingController(text: user.displayedName);
      _profileUriController =
          TextEditingController(text: user.profilePictureUri);
      _hidePic = user.hideProfilePicture;
    } else {
      _displayedNameController = TextEditingController();
      _profileUriController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _displayedNameController.dispose();
    _profileUriController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final profileViewModel = context.read<ProfileViewModel>();

    await profileViewModel.updateProfile(
      displayedName: _displayedNameController.text.trim(),
      profileUri: _profileUriController.text.trim(),
      hideProfilePicture: _hidePic,
    );

    if (!mounted) return;

    if (profileViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(profileViewModel.error!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _displayedNameController,
                decoration: const InputDecoration(
                  labelText: 'Displayed name',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _profileUriController,
                decoration: const InputDecoration(
                  labelText: 'Profile picture URL',
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _hidePic,
                title: const Text('Hide profile picture'),
                onChanged: (value) {
                  setState(() {
                    _hidePic = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    profileViewModel.isLoading ? null : _onSave,
                child: profileViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
