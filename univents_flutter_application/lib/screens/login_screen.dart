import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_flutter_application/screens/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final SupabaseClient supabase = Supabase.instance.client;

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Check if the user is already signed in
    final session = supabase.auth.currentSession;
    if (session != null) {
    }

    // Listen for changes in authentication state
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
      });
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      const webClientId =
          '31890867632-1thbar05us92e7ptrouma5ehi9atovh9.apps.googleusercontent.com';
      const iosClientId =
          '31890867632-kl68jmhunrc65o5gh6aj6nmosjdkji4q.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS ? iosClientId : null,
        serverClientId: webClientId,
      );

      await googleSignIn
          .signOut(); // Ensure user is logged out before logging in again.

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign-in aborted by user');
      }

      final email = googleUser.email;
      if (!email.endsWith('@addu.edu.ph')) {
        // Block non-addu emails
        await supabase.auth.signOut();
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Access Denied'),
              content: const Text('Only @addu.edu.ph emails are allowed.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK')),
              ],
            ),
          );
        }
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Missing Google Auth Token(s)');
      }

      final authRes = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final userId = authRes.session?.user.id;
      if (userId == null) throw Exception("No user ID returned");

      // Check if the profile exists before inserting
      final profileCheck = await supabase
          .from('profiles')
          .select('id, role')
          .eq('id', userId)
          .maybeSingle();

      print('Profile Check: $profileCheck');

      if (profileCheck == null) {
        await supabase.from('profiles').insert({
          'id': userId,
          'email': email,
          'role': 'student',
        });
      } else {
        final role = profileCheck['role'];
        if (role == null) {
          await supabase.from('profiles').update({
            'role': 'student',
          }).eq('id', userId);
        }
      }

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => Dashboard(
              name: googleUser.displayName ?? 'No name',
              email: email,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Google sign-in failed: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
                Color.fromARGB(255, 194, 197, 243),
                Color.fromARGB(255, 170, 174, 225),
              ],
              stops: [0.0, 0.7, 0.85, 1.0],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 45.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Image.asset('assets/addu.png', height: 150),
                  const SizedBox(height: 10),
                  const Text('UNI-VENTS',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo)),
                  const SizedBox(height: 32),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Username',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Color.fromARGB(255, 33, 13, 120)))),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'abc@email.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Color.fromARGB(255, 33, 13, 120)))),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: 'Your password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.6,
                            child: Switch(
                              value: _rememberMe,
                              onChanged: (val) =>
                                  setState(() => _rememberMe = val),
                            ),
                          ),
                          const Text('Remember Me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 13, 120),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 45, 59, 135),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 24),
                          const Text(
                            'SIGN IN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Or',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 33, 13, 120))),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Image.network(
                      'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                      height: 40,
                    ),
                    label: const Text('Login with Google',
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon:
                        Icon(Icons.facebook, color: Colors.blue[800], size: 30),
                    label: const Text('Login with Facebook',
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {}, child: const Text('Sign up')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
