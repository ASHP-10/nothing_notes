import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/constants/Exceptions/auth_exceptions.dart';
import 'dart:developer';
import 'package:nothing_notes/services/navigation_service.dart';
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
      body: Column(
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
                  final userCredential = await AuthService.firebase().register(
                    email: email,
                    password: password,
                  );

                  log(userCredential.toString());
                  await NavigationService.defaultPopUpDialog(
                    "Successfully Registered",
                  );
                  NavigationService.navigateAndRemoveUntil(loginRoute);
                } on EmailAlreadyInUseAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "The specified email is already in use",
                  );
                } on InvalidEmailAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "The email is invalid",
                  );
                } on OperationNotAllowedAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Cannot register using this method",
                  );
                } on WeakPasswordAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Password is too Weak",
                  );
                } on TooManyRequestsAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Too many requests, please try again",
                  );
                } on UserTokenExpiredAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "User refresh token is expired",
                  );
                } on NetworkAuthException {
                  await NavigationService.defaultPopUpDialog(
                    "An Error Occured",
                    "Please check your Internet connection and try again",
                  );
                } on GenericRegistrationAuthException {
                  log("Registeration failed");
                }
              },
              child: const Text("Register")),
          TextButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterView()));
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registered? login here"))
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
