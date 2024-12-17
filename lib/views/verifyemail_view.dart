import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/services/auth_service.dart';

class VerifyemailView extends StatefulWidget {
  const VerifyemailView({super.key});

  @override
  State<VerifyemailView> createState() => _VerifyemailViewState();
}

class _VerifyemailViewState extends State<VerifyemailView> {
  late final TextEditingController _verificationCode;

  @override
  void initState() {
    _verificationCode = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _verificationCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Email Verification"),
          backgroundColor: Colors.redAccent,
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().emailVerification();
                  await showEmailVerification(context);
                },
                child: const Text("Send Email with The Login Code."))
          ],
        ));
  }
}

Future<void> showEmailVerification(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Email verification"),
        content: const Text(
            "An email has been sent to the email, please follow the instructions to verify the email and try to login."),
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
