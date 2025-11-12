

import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/role_selector.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? selectedRole;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.primaryColor,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Create Your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create an account to manage your profile",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 40),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Full Name",
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _emailController,
                            hintText: "Email",
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select Role",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          RoleSelector(
                            selectedRole: selectedRole,
                            onSelect: (role) => setState(() => selectedRole = role),
                          ),
                          const SizedBox(height: 30),

                          CustomButton(
                            text: "Sign Up",
                            onPressed: () async {
                              if (selectedRole == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please select your role first")),
                                );
                                return;
                              }

                              final error = await authProvider.signUp(
                                _nameController.text.trim(),
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                selectedRole!,
                              );

                              if (error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Signup successful")),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfileSetupScreen(
                                      role: selectedRole![0].toUpperCase() +
                                          selectedRole!.substring(1).toLowerCase(),
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error)),
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 25),
                          const Text(" Or Sign Up With",style: TextStyle(color: Colors.black45),),
                          const SizedBox(height: 15),

                          // ✅ Only Google button remains
                          GestureDetector(
                            onTap: () async {
                              final user = await authProvider.signInWithGoogle(context);
                              if (user != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Signed in successfully with Google")),
                                );
                                // You may navigate if needed after Google sign-in
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Google Sign-In failed.")),
                                );
                              }
                            },
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Image.network(
                                'https://developers.google.com/identity/images/g-logo.png',
                                height: 26,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: AppTheme.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (authProvider.isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          ),
      ],
    );
  }
}
