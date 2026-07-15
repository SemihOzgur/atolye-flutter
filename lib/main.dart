import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(1280, 800),
      center: true,
      backgroundColor: Color(0xFF121212),
      skipTaskbar: false,
      title: 'Leather Care Admin',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const LeatherCareAdminApp());
}

class LeatherCareAdminApp extends StatelessWidget {
  const LeatherCareAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1B5E20),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leather Care Admin',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: baseColorScheme.copyWith(
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFF4CAF50),
          surface: const Color(0xFF1A1D1B),
          onSurface: const Color(0xFFF5F7F5),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1110),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121513),
          foregroundColor: Color(0xFFF5F7F5),
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF161916),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFF263229), width: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF141815),
          hintStyle: const TextStyle(color: Color(0xFF8D978F)),
          labelStyle: const TextStyle(color: Color(0xFFD9E2DA)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2D3A31)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2D3A31)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF5F7F5),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF5F7F5),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFFD9E2DA),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFFB9C3BB),
          ),
        ),
      ),
      home: const LoginPlaceholderPage(),
    );
  }
}

class LoginPlaceholderPage extends StatelessWidget {
  const LoginPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F1110),
              Color(0xFF121813),
              Color(0xFF1A241D),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF1B5E20).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          color: Color(0xFF7FCF88),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Giriş',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Leather Care Admin paneline hoş geldiniz. Bu ekran daha sonra auth feature altındaki gerçek giriş akışına bağlanacak.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        enabled: false,
                        decoration: const InputDecoration(
                          labelText: 'Kullanıcı adı',
                          hintText: 'Yakında bağlanacak',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        enabled: false,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Şifre',
                          hintText: 'Yakında bağlanacak',
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: null,
                        child: const Text('Giriş Yap'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
