import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/constants/Exceptions/auth_exceptions.dart';
import 'dart:developer';

import 'package:nothing_notes/services/auth_service.dart';

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
        future: AuthService.firebase().initialise(),
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
                          await AuthService.firebase().signIn(
                            email: email,
                            password: password,
                          );

                          final user = AuthService.firebase().currentUser;

                          if (user != null) {
                            if (user.isEmailVerified) {
                              log("Email is verified.");
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainRoute, (context) => false);
                            } else {
                              log("Email is not verified.");
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => const VerifyemailView())
                              // );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyEmailRoute, (route) => false);
                            }
                          }
                        } on UserNotFoundException {
                          await showErrorDialog(
                              context, "No Username found for the given email");
                        } on UserDisabledException {
                          await showErrorDialog(
                              context, "User has been disaled by the admin");
                        } on InvalidEmailException {
                          await showErrorDialog(
                              context, "Given email is not a valid email");
                        } on WrongPasswordException {
                          await showErrorDialog(context,
                              "Wrong password or the password has not been set");
                        } on TooManyRequestsException {
                          await showErrorDialog(
                              context, "Too many requests, please ");
                        } on UserTokenExpiredException {
                          await showErrorDialog(context, "User token expired");
                        } on NetworkException {
                          await showErrorDialog(context,
                              "Please check your network connection and try again");
                        } on InvalidCredentialException {
                          await showErrorDialog(context,
                              "Given password is incorrect for the email provided");
                        } on OperationNotAllowedException {
                          await showErrorDialog(
                              context, "This login method is not enabled yet");
                        } on GenericLoginException {
                          log("Login failed");
                        }
                      },
                      child: const Text("Login")),
                  TextButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            registerRoute, (route) => false);
                      },
                      child: const Text("Not yet registered? Register here"))
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
