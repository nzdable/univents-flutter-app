import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final SupabaseClient supabase = Supabase.instance.client;

class _LoginState extends State<Login> {
  String? _userID;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userID = data.session?.user?.id;
      });
    });
  }

  Future<void> _nativeGoogleSignIn() async {
    const webClientId = '451923571225-16d5gkkhbib2bvov02p7fgv40mi2jiff.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;

    final accessToken = googleAuth?.accessToken;
    final idToken = googleAuth?.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_userID ?? 'Not signed in'),
            ElevatedButton(
              onPressed: () async {
                if (!kIsWeb && Platform.isAndroid) {
                  await _nativeGoogleSignIn();
                } else {
                  await supabase.auth.signInWithOAuth(
                    OAuthProvider.google,
                    redirectTo: kIsWeb
                        ? 'http://localhost:3000'
                        : null,
                  );
                }
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
