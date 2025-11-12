
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
// import 'package:influencer_marketplace_application/providers/brand_provider.dart';
// import 'package:influencer_marketplace_application/screens/Brand/dashboard/brand_dashboard.dart';
// import 'package:influencer_marketplace_application/screens/auth/forgot_password_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/signup_screen.dart';
// import 'package:influencer_marketplace_application/screens/influencer/influencer_dashboard.dart';
// import 'package:influencer_marketplace_application/screens/influencer/onboarding_screen.dart';
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

//   Future<void> _navigateAfterLogin(String role, String userId) async {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (role.toLowerCase() == 'influencer') {
//         final influencerProvider = context.read<InfluencerProvider>();
//         await influencerProvider.fetchInfluencer(userId);

//         final completed = influencerProvider.influencer?.onboardingCompleted ?? false;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => completed
//                 ? const InfluencerDashboard()
//                 : const OnboardingScreen(),
//           ),
//         );
//       } else if (role.toLowerCase() == 'brand') {
//         final brandProvider = context.read<BrandProvider>();
//         await brandProvider.fetchBrand(userId);
//         if (brandProvider.brand != null) {
//           await brandProvider.fetchCampaigns(brandProvider.brand!.id);
//         }

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const BrandDashboard()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Unknown role! Please contact support.")),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: AppTheme.primaryColor,
//           body: SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 60),
//                 const Text(
//                   "Welcome Back!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Please login with your personal information.",
//                   style: TextStyle(color: Colors.white70, fontSize: 14),
//                 ),
//                 const SizedBox(height: 40),

//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40),
//                       ),
//                     ),
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//                       child: Column(
//                         children: [
//                           CustomTextField(
//                             controller: _emailController,
//                             hintText: "Enter Email",
//                             prefixIcon: Icons.email_outlined,
//                           ),
//                           const SizedBox(height: 16),
//                           CustomTextField(
//                             controller: _passwordController,
//                             hintText: "Enter Password",
//                             prefixIcon: Icons.lock_outline,
//                             obscureText: _obscure,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                   _obscure ? Icons.visibility_off : Icons.visibility),
//                               onPressed: () => setState(() => _obscure = !_obscure),
//                             ),
//                           ),
//                           const SizedBox(height: 10),

//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: TextButton(
//                               onPressed: () => Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
//                               ),
//                               child: const Text(
//                                 "Forgot Password?",
//                                 style: TextStyle(color: AppTheme.primaryColor),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),

//                           CustomButton(
//                             text: "Login",
//                             onPressed: () async {
//                               final error = await authProvider.login(
//                                 _emailController.text.trim(),
//                                 _passwordController.text.trim(),
//                               );

//                               if (error == null && authProvider.currentUser != null) {
//                                 final user = authProvider.currentUser!;
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text("Welcome, ${user.role}!")),
//                                 );
//                                 await _navigateAfterLogin(user.role, user.id);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(error ?? "Login failed")),
//                                 );
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 25),

//                           const Text(" Or Login With",style: TextStyle(color: Colors.black45),),
//                           const SizedBox(height: 15),

//                           // ✅ Only Google button remains
//                           GestureDetector(
//                             onTap: () async {
//                               final user = await authProvider.signInWithGoogle(context);
//                               if (user != null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text("Signed in as ${user.role}")),
//                                 );
//                                 await _navigateAfterLogin(user.role, user.id);
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text("Google Sign-In failed.")),
//                                 );
//                               }
//                             },
//                             child: CircleAvatar(
//                               radius: 22,
//                               backgroundColor: Colors.white,
//                               child: Image.network(
//                                 'https://developers.google.com/identity/images/g-logo.png',
//                                 height: 26,
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 30),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text("Don’t have an account? "),
//                               TextButton(
//                                 onPressed: () => Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (_) => const SignUpScreen()),
//                                 ),
//                                 child: const Text(
//                                   "Sign Up",
//                                   style: TextStyle(color: AppTheme.primaryColor),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         if (authProvider.isLoading)
//           Container(
//             color: Colors.black.withOpacity(0.4),
//             child: const Center(
//               child: CircularProgressIndicator(color: AppTheme.primaryColor),
//             ),
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
import 'package:influencer_marketplace_application/providers/brand_provider.dart';
import 'package:influencer_marketplace_application/screens/Brand/dashboard/brand_dashboard.dart';
import 'package:influencer_marketplace_application/screens/auth/forgot_password_screen.dart';
import 'package:influencer_marketplace_application/screens/auth/signup_screen.dart';
import 'package:influencer_marketplace_application/screens/influencer/influencer_dashboard.dart';
import 'package:influencer_marketplace_application/screens/influencer/onboarding_screen.dart';
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

  Future<void> _navigateAfterLogin(String role, String userId) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (role.toLowerCase() == 'influencer') {
        final influencerProvider = context.read<InfluencerProvider>();
        await influencerProvider.fetchInfluencer(userId);

        final completed = influencerProvider.influencer?.onboardingCompleted ?? false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => completed
                ? const InfluencerDashboard()
                : const OnboardingScreen(),
          ),
        );
      } else if (role.toLowerCase() == 'brand') {
        final brandProvider = context.read<BrandProvider>();
        await brandProvider.fetchBrand(userId);
        if (brandProvider.brand != null) {
          await brandProvider.fetchCampaigns(brandProvider.brand!.id);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BrandDashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unknown role! Please contact support.")),
        );
      }
    });
  }

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
                  "Welcome Back!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please login with your personal information.",
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
                            controller: _emailController,
                            hintText: "Enter Email",
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Enter Password",
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscure,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: AppTheme.primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          CustomButton(
                            text: "Login",
                            onPressed: () async {
                              final error = await authProvider.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );

                              if (error == null && authProvider.currentUser != null) {
                                final user = authProvider.currentUser!;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Welcome, ${user.role}!")),
                                );
                                await _navigateAfterLogin(user.role, user.id);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error ?? "Login failed")),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 25),

                          const Text(
                            " Or Login With",
                            style: TextStyle(color: Colors.black45),
                          ),
                          const SizedBox(height: 15),

                          // ✅ Full-width circular Google icon
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  icon: Image.network(
                                    'https://developers.google.com/identity/images/g-logo.png',
                                    height: 28,
                                  ),
                                  onPressed: () async {
                                    final user = await authProvider.signInWithGoogle(context);
                                    if (user != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Signed in as ${user.role}")),
                                      );
                                      await _navigateAfterLogin(user.role, user.id);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Google Sign-In failed.")),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don’t have an account? "),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
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
