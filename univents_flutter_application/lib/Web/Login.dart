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
        _userID = data.session?.user.id;
      });
    });
  }
Future<void> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn;

    if (kIsWeb) {
      // Web client ID is REQUIRED for Web
      googleSignIn = GoogleSignIn(
        clientId: '31890867632-1thbar05us92e7ptrouma5ehi9atovh9.apps.googleusercontent.com',
      );
    } else if (Platform.isIOS) {
      googleSignIn = GoogleSignIn(
        clientId: '31890867632-kl68jmhunrc65o5gh6aj6nmosjdkji4q.apps.googleusercontent.com',
      );
    } else {
      // No clientId on Android!
      googleSignIn = GoogleSignIn();
    }

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Sign-in aborted by user');
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw Exception('Missing Google Auth Token(s)');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  } catch (e) {
    debugPrint('Google sign-in failed: $e');
    rethrow;
  }
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
                 /// TODO: update the Web client ID with your own.
  ///
  /// Web Client ID that you registered with Google Cloud.
  const webClientId = '31890867632-1thbar05us92e7ptrouma5ehi9atovh9.apps.googleusercontent.com';

  /// TODO: update the iOS client ID with your own.
  ///
  /// iOS Client ID that you registered with Google Cloud.
  const iosClientId = '31890867632-kl68jmhunrc65o5gh6aj6nmosjdkji4q.apps.googleusercontent.com';

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser!.authentication;
  final accessToken = googleAuth.accessToken;
  final idToken = googleAuth.idToken;

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
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
