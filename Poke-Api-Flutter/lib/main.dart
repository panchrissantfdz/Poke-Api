import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practicas/notifications/notification_service.dart';
import 'package:practicas/Widgets/login_user.dart';
import 'package:practicas/Widgets/home_screen.dart';
import 'package:practicas/auth/auth_providers.dart';
import 'package:practicas/auth/theme_provider.dart';

import 'Design/themes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Forzar login en cada inicio en frío: cerrar sesión previa
  await FirebaseAuth.instance.signOut();
  
  // Inicializar notificaciones y solicitar permisos
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);
    return themeState.when(
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
              body: Column(
                children: [CircularProgressIndicator(), 
                const SizedBox(height: 8,),
                Text('Iniciando Sesión'),])),
      ),
      error: (e, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: PokemonThemes.lightTheme,
        home: Scaffold(body: Center(child: Text('Error de tema: $e'))),
      ),
      data: (appTheme) => MaterialApp(
        title: 'Pokédex',
        theme: themeDataFor(appTheme),
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
      data: (user) => user != null ? const HomeScreen() : const LoginUser(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error de autenticación: $e')),
      ),
    );
  }
}

