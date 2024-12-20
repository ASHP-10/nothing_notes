import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/constants/Exceptions/auth_exceptions.dart';
import 'dart:developer';
import 'package:nothing_notes/services/auth_service.dart';
import 'package:nothing_notes/services/navigation_service.dart';

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
      body: Column(
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
            decoration: const InputDecoration(hintText: "Enter your password"),
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
                      await NavigationService.navigateAndRemoveUntil(mainRoute);
                    } else {
                      log("Email is not verified.");
                      await NavigationService.navigateTo(verifyEmailRoute);
                    }
                  }
                } on UserNotFoundAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "No Username found for the given email",
                  );
                } on UserDisabledAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "User has been disabled by the admin",
                  );
                } on InvalidEmailAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Given email is not a valid email",
                  );
                } on WrongPasswordAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Wrong password or the password has not been set",
                  );
                } on TooManyRequestsAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Too many requests, please try again later",
                  );
                } on UserTokenExpiredAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "User token expired",
                  );
                } on NetworkAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Please check your network connection and try again",
                  );
                } on InvalidCredentialAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Given password is incorrect for the email provided",
                  );
                } on OperationNotAllowedAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "This login method is not enabled yet",
                  );
                } on GenericLoginAuthException {
                  log("Login failed");
                }
              },
              child: const Text("Login")),
          TextButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not yet registered? Register here"))
        ],
      ),
      backgroundColor: Colors.yellow,
    );
  }
}
