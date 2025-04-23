import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Controllers/Login_Controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _userID;
  String? _email;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();

    final session = supabase.auth.currentSession;
    if (session != null) {
      _verifySession(session);
    }

    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        _verifySession(session);
      }
    });
  }

  void _verifySession(Session session) {
    setState(() {
      _userID = session.user.id;
      _email = session.user.email;
      _statusMessage = "Signed in!";
    });
  }

  Future<void> _handleLogin() async {
    final result = await handleLogin();

    if (result != null) {
      setState(() {
        _userID = result['userID'];
        _email = result['email'];
        _statusMessage = "Signed in!";
      });
    } else {
      setState(() {
        _userID = null;
        _email = null;
        _statusMessage = "Sign-in failed.";
      });
    }
  }

  void _clearSession() {
    setState(() {
      _userID = null;
      _email = null;
      _statusMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = _userID != null;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLoggedIn ? 'Signed in as $_email' : 'Not signed in',
              style: const TextStyle(fontSize: 18),
            ),
            if (_statusMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: _statusMessage!.contains('failed') ||
                            _statusMessage!.contains("Error")
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoggedIn
                  ? () => handleSignOut(_clearSession)
                  : _handleLogin,
              child: Text(isLoggedIn ? 'Sign Out' : 'Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
