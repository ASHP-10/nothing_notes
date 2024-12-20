import 'package:flutter/material.dart';
import 'package:nothing_notes/services/auth_service.dart';
import 'package:nothing_notes/services/navigation_service.dart';

class VerifyemailView extends StatefulWidget {
  const VerifyemailView({super.key});

  @override
  State<VerifyemailView> createState() => _VerifyemailViewState();
}

class _VerifyemailViewState extends State<VerifyemailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                  await NavigationService.defaultPopUpDialog(
                    "Email Verification",
                    "An email as been sent to the specified email, please verify and then login again.",
                  );
                  NavigationService.navigateBackTo();
                },
                child: const Text(
                  "Send Email with The Login Code.",
                ))
          ],
        ));
  }
}
