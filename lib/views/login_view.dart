import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/firebase_options.dart';
import 'dart:developer';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: "Enter your email. eg: hello@nothing.com"),
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _password,
                    decoration:
                        const InputDecoration(hintText: "Enter your password"),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          final user = userCredential.user;

                          if (user != null) {
                            if (user.emailVerified) {
                              log("Email is verified.");
                              Navigator.of(context).pushNamedAndRemoveUntil(mainRoute, (context) => false);
                            } else {
                              log("Email is not verified.");
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => const VerifyemailView())
                              // );
                              Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            log("Invalid User: No user found for that email.");
                          } else if (e.code == 'wrong-password') {
                            log("Wrong Password: The password is incorrect.");
                          } else if (e.code == 'invalid-email') {
                            log(
                                "Invalid Email: The email address is badly formatted.");
                          } else {
                            log("Error: ${e.message}");
                          }
                        }
                      },
                      child: const Text("Login")),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                        Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                      }, 
                      child: const Text("Not yet registered? Register here")
                    )
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
      backgroundColor: Colors.yellow,
    );
  }
}
