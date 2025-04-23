import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_flutter_application/Web/secret.dart';

final SupabaseClient supabase = Supabase.instance.client;

Future<void> nativeGoogleSignIn() async {
  final webClientId = secret.webClientId;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId: webClientId,
  );

  final googleUser = await googleSignIn.signIn();
  final googleAuth = await googleUser?.authentication;

  final accessToken = googleAuth?.accessToken;
  final idToken = googleAuth?.idToken;

  if (accessToken == null || idToken == null) {
    throw Exception('Google sign-in failed: missing tokens.');
  }

  await supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: idToken,
    accessToken: accessToken,
  );
}

Future<void> handleGoogleSignIn() async {
  if (!kIsWeb && Platform.isAndroid) {
    await nativeGoogleSignIn();
  } else {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? 'http://localhost:3000' : null,
    );
  }
}

Future<Map<String, String>?> handleLogin() async {
  try {
    await handleGoogleSignIn();
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    return {
      'userID': user.id,
      'email': user.email ?? '',
    };
  } catch (e) {
    debugPrint('Error during login: $e');
    return null;
  }
}

Future<void> handleSignOut(Function clearStateCallback) async {
  try {
    await supabase.auth.signOut();
    clearStateCallback();
  } catch (e) {
    debugPrint('Error signing out: $e');
  }
}