import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/constants/Exceptions/auth_exceptions.dart';
import 'dart:developer';

import 'package:nothing_notes/services/auth_service.dart';

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
                      decoration: const InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.red)),
                    ),
                    TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            final userCredential =
                                await AuthService.firebase().register(
                              email: email,
                              password: password,
                            );

                            log(userCredential.toString());
                            await showSuccesfullyRegistered(context);
                          } on EmailAlreadyInUseException {
                            showErrorDialog(context,
                                "The specified email is already in use");
                          } on InvalidEmailException {
                            showErrorDialog(context, "The email is invalid");
                          } on OperationNotAllowedException {
                            showErrorDialog(
                                context, "Cannot register using this method");
                          } on WeakPasswordException {
                            showErrorDialog(context, "Password is too Weak");
                          } on TooManyRequestsException {
                            showErrorDialog(
                                context, "Too many requests, please try again");
                          } on UserTokenExpiredException {
                            showErrorDialog(
                                context, "User refresh token is expired");
                          } on NetworkException {
                            showErrorDialog(context,
                                "Please check your Internet connection and try again");
                          } on GenericRegistrationException {
                            log("Registeration failed");
                          }
                        },
                        child: const Text("Register")),
                    TextButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        },
                        child: const Text("Already registered? Register here"))
                  ],
                );
              default:
                return const Text("Loading...");
            }
          },
          future: AuthService.firebase().initialise()),
      backgroundColor: Colors.black,
    );
  }
}

Future<void> showSuccesfullyRegistered(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Registration"),
        content: const Text("Successfully registered"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (_) => false);
              },
              child: const Text("OK"))
        ],
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("An error occured."),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"))
        ],
      );
    },
  );
}
