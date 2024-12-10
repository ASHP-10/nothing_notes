import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/firebase_options.dart';
import 'dart:developer';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Registration"),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder(
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
                        hintText: "Enter your email. eg: hello@nothing.com",
                        hintStyle: TextStyle(color: Colors.red)),
                    style: const TextStyle(color: Colors.red),
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _password,
                    decoration:
                        const InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.red)
                        ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);

                        log(userCredential.toString());
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          log(
                              "Invalid User: No user found for that email.");
                        } else if (e.code == 'weak-password') {
                          log("Weak Password: The password is too weak.");
                        } else {
                          log("Error: ${e.code}");
                        }
                      }
                    },
                    child: const Text("Register")
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    }, 
                    child: const Text("Already registered? Register here")
                  )
                ],
              );
            default: 
              return const Text("Loading...");
          }
        },
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
