
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/forgot_password_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/home_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/signup_screen.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscure = true;

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: AppTheme.backgroundColor,
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Welcome Back 👋",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "Login to your account",
//                     style: TextStyle(color: AppTheme.hintColor),
//                   ),
//                   const SizedBox(height: 40),

//                   // Email
//                   CustomTextField(
//                     controller: _emailController,
//                     hintText: "Email",
//                     prefixIcon: Icons.email_outlined,
//                   ),
//                   const SizedBox(height: 16),

//                   // Password
//                   CustomTextField(
//                     controller: _passwordController,
//                     hintText: "Password",
//                     prefixIcon: Icons.lock_outline,
//                     obscureText: _obscure,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscure ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () => setState(() => _obscure = !_obscure),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Forgot Password
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const ForgotPasswordScreen()),
//                       ),
//                       child: const Text(
//                         "Forgot Password?",
//                         style: TextStyle(color: AppTheme.primaryColor),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Login Button
//                   CustomButton(
//                     text: "Login",
//                     onPressed: () async {
//                       final error = await authProvider.login(
//                         _emailController.text.trim(),
//                         _passwordController.text.trim(),
//                       );

//                       if (error == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Login successful")),
//                         );

//                         // ✅ Navigate to HomeScreen
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (_) => const HomeScreen()),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(error)),
//                         );
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Google Sign-In Button
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       side: const BorderSide(color: Colors.grey),
//                     ),
//                     onPressed: () async {
//                       final user = await authProvider.signInWithGoogle(context);

//                       if (user != null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Signed in with Google")),
//                         );

//                         // ✅ Navigate to HomeScreen
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (_) => const HomeScreen()),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("Google sign-in cancelled or failed")),
//                         );
//                       }
//                     },
//                     icon: Image.network(
//                       'https://developers.google.com/identity/images/g-logo.png',
//                       height: 24,
//                     ),
//                     label: const Text("Sign in with Google"),
//                   ),
//                   const SizedBox(height: 30),

//                   // Signup
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Don't have an account? "),
//                       TextButton(
//                         onPressed: () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (_) => const SignUpScreen()),
//                         ),
//                         child: const Text(
//                           "Sign Up",
//                           style: TextStyle(color: AppTheme.primaryColor),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         // ✅ Loading Overlay
//         if (authProvider.isLoading)
//           Container(
//             color: Colors.black.withOpacity(0.4),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 color: AppTheme.primaryColor,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/screens/auth/brand_dashboard.dart';
import 'package:influencer_marketplace_application/screens/auth/forgot_password_screen.dart';
import 'package:influencer_marketplace_application/screens/auth/influencer_dashboard.dart';
import 'package:influencer_marketplace_application/screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  void _navigateToDashboard(String role) {
    if (role.toLowerCase() == 'influencer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InfluencerDashboardScreen()),
      );
    } else if (role.toLowerCase() == 'brand') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BrandDashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unknown role! Please contact support.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Login to your account",
                    style: TextStyle(color: AppTheme.hintColor),
                  ),
                  const SizedBox(height: 40),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen()),
                      ),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  CustomButton(
                    text: "Login",
                    onPressed: () async {
                      final error = await authProvider.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (error == null && authProvider.currentUser != null) {
                        final role = authProvider.currentUser!.role;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Welcome, $role!")),
                        );
                        _navigateToDashboard(role);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error ?? "Login failed")),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    onPressed: () async {
                      final user = await authProvider.signInWithGoogle(context);

                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Signed in as ${user.role} via Google")),
                        );
                        _navigateToDashboard(user.role);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Google sign-in cancelled or failed.")),
                        );
                      }
                    },
                    icon: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 24,
                    ),
                    label: const Text("Sign in with Google"),
                  ),
                  const SizedBox(height: 30),

                  // Signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()),
                        ),
                        child: const Text(
                          "Sign Up",
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

        // ✅ Loading Overlay
        if (authProvider.isLoading)
          Container(
            color: Colors.black.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
