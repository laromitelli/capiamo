import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../domain/entities/message.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../home/viewmodel/home_viewmodel.dart';
import '../viewmodel/message_form_viewmodel.dart';

class MessageFormPage extends StatefulWidget {
  const MessageFormPage({super.key});

  @override
  State<MessageFormPage> createState() => _MessageFormPageState();
}

class _MessageFormPageState extends State<MessageFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    final homeViewModel = context.read<HomeViewModel>();
    final messageFormViewModel = context.read<MessageFormViewModel>();

    final user = authViewModel.currentUser;
    final position = homeViewModel.currentPosition;

    if (user == null || position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing user or location'),
        ),
      );
      return;
    }

    await messageFormViewModel.createMessage(
      userId: user.id,
      message: _messageController.text.trim(),
      lat: position.latitude,
      lon: position.longitude,
    );

    if (!mounted) return;

    if (messageFormViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(messageFormViewModel.error!)),
      );
      return;
    }

    final Message? created = messageFormViewModel.created;
    if (created != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Situa created!')),
      );
      Navigator.of(context).pop();
      // optionally trigger refresh
      await homeViewModel.loadNearbyMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageFormViewModel = context.watch<MessageFormViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Situa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: "What's the situa?",
                ),
                maxLines: 3,
                validator: Validators.message,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    messageFormViewModel.isLoading ? null : _onSubmit,
                child: messageFormViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
