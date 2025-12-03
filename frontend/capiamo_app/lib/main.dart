import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/message_repository.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/home/viewmodel/home_viewmodel.dart';
import 'features/message_form/viewmodel/message_form_viewmodel.dart';
import 'features/profile/viewmodel/profile_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();
  final userRepository = UserRepository(dioClient: dioClient);
  final messageRepository = MessageRepository(dioClient: dioClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(userRepository: userRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(messageRepository: messageRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageFormViewModel(messageRepository: messageRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(userRepository: userRepository),
        ),
      ],
      child: const CapiamoApp(),
    ),
  );
}
