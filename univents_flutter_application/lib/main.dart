import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Web/Login.dart';
import 'Web/secret.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseUrl = secret.SUPABASE_URL!;
  final supabaseAnonKey = secret.SUPABASE_ANON_KEY!;

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final supabase = Supabase.instance.client;

  final uri = Uri.base;

  if (kIsWeb &&
      (uri.queryParameters.containsKey('access_token') ||
          uri.queryParameters.containsKey('refresh_token') ||
          uri.queryParameters.containsKey('error'))) {
    try {
      await supabase.auth.getSessionFromUrl(uri);
      html.window.history.replaceState(null, '', '/');
    } catch (e) {
      debugPrint('OAuth session restoration failed: $e');
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}
