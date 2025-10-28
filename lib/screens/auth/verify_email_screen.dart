import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Verify Email"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_unread_outlined,
                  size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: 20),
              Text(
                isVerified
                    ? "Your email has been verified! 🎉"
                    : "Please check your inbox for the verification email.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 30),

              CustomButton(
                text: isVerified ? "Continue" : "Resend Verification Email",
                onPressed: () {
                  setState(() => isVerified = !isVerified);
                  if (isVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Email verified successfully (UI only)")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Verification email re-sent")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
