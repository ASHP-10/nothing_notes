import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            }, 
            child: const Text("Send Email with The Login Code.")
          )
        ],
      )
    );
  }
}