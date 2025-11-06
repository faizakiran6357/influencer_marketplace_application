
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/role_selector.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? selectedRole; // Influencer or Brand
//   bool _obscure = true;

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: AppTheme.backgroundColor,
//           appBar: AppBar(
//             title: const Text("Create Account"),
//             backgroundColor: AppTheme.primaryColor,
//           ),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Sign Up to Get Started 🚀",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   // Name
//                   CustomTextField(
//                     controller: _nameController,
//                     hintText: "Full Name",
//                     prefixIcon: Icons.person_outline,
//                   ),
//                   const SizedBox(height: 16),

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
//                   const SizedBox(height: 20),

//                   // Role Selection
//                   const Text(
//                     "Select Role",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   RoleSelector(
//                     selectedRole: selectedRole,
//                     onSelect: (role) => setState(() => selectedRole = role),
//                   ),
//                   const SizedBox(height: 30),

//                   // Sign Up Button
//                   CustomButton(
//                     text: "Sign Up",
//                     onPressed: () async {
//                       if (selectedRole == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("Please select your role first")),
//                         );
//                         return;
//                       }

//                       final error = await authProvider.signUp(
//                         _nameController.text.trim(),
//                         _emailController.text.trim(),
//                         _passwordController.text.trim(),
//                         selectedRole!,
//                       );

//                       if (error == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Signup successful")),
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 ProfileSetupScreen(role: selectedRole!),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(error)),
//                         );
//                       }
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   // Google Sign Up Button
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
//                       final error =
//                           await authProvider.loginWithGoogle(context);

//                       if (error == null) {
//                         final user = await authProvider.handleGoogleUser();
//                         if (user != null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text("Signed up with Google")),
//                           );
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   ProfileSetupScreen(role: user.role),
//                             ),
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(error)),
//                         );
//                       }
//                     },
//                     icon: Image.network(
//                       'https://developers.google.com/identity/images/g-logo.png',
//                       height: 24,
//                     ),
//                     label: const Text("Sign up with Google"),
//                   ),

//                   const SizedBox(height: 25),

//                   // Already have account?
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account? "),
//                       TextButton(
//                         onPressed: () => Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const LoginScreen(),
//                           ),
//                         ),
//                         child: const Text(
//                           "Login",
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

//         // ✅ Loading Overlay (for both email + google sign-up)
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
// correct code above//
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/role_selector.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? selectedRole;
//   bool _obscure = true;

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: AppTheme.backgroundColor,
//           appBar: AppBar(
//             title: const Text("Create Account"),
//             backgroundColor: AppTheme.primaryColor,
//           ),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Sign Up to Get Started 🚀",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   // Name
//                   CustomTextField(
//                     controller: _nameController,
//                     hintText: "Full Name",
//                     prefixIcon: Icons.person_outline,
//                   ),
//                   const SizedBox(height: 16),

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
//                   const SizedBox(height: 20),

//                   // Role
//                   const Text(
//                     "Select Role",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   RoleSelector(
//                     selectedRole: selectedRole,
//                     onSelect: (role) => setState(() => selectedRole = role),
//                   ),
//                   const SizedBox(height: 30),

//                   // Sign Up Button
//                   CustomButton(
//                     text: "Sign Up",
//                     onPressed: () async {
//                       if (selectedRole == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("Please select your role first")),
//                         );
//                         return;
//                       }

//                       final error = await authProvider.signUp(
//                         _nameController.text.trim(),
//                         _emailController.text.trim(),
//                         _passwordController.text.trim(),
//                         selectedRole!,
//                       );

//                       if (error == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Signup successful")),
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 ProfileSetupScreen(role: selectedRole!),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(error)),
//                         );
//                       }
//                     },
//                   ),

//                   const SizedBox(height: 25),

//                   // Google Sign-In Button
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       side: const BorderSide(color: Colors.grey),
//                       elevation: 3,
//                       shadowColor: Colors.black26,
//                     ),
//                     onPressed: () async {
//                       final user =
//                           await authProvider.signInWithGoogle(context);
//                       if (user != null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("Signed in with Google successfully")),
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 ProfileSetupScreen(role: user.role),
//                           ),
//                         );
//                       }
//                     },
//                     icon: Image.network(
//                       'https://developers.google.com/identity/images/g-logo.png',
//                       height: 24,
//                     ),
//                     label: const Text(
//                       "Sign up with Google",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 25),

//                   // Already have account
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account? "),
//                       TextButton(
//                         onPressed: () => Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const LoginScreen(),
//                           ),
//                         ),
//                         child: const Text(
//                           "Login",
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

//         // Loading overlay
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
// correct//
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/role_selection_screen.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/role_selector.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? selectedRole;
//   bool _obscure = true;

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: AppTheme.backgroundColor,
//           appBar: AppBar(
//             title: const Text("Create Account"),
//             backgroundColor: AppTheme.primaryColor,
//           ),
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Sign Up to Get Started 🚀",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   // Name
//                   CustomTextField(
//                     controller: _nameController,
//                     hintText: "Full Name",
//                     prefixIcon: Icons.person_outline,
//                   ),
//                   const SizedBox(height: 16),

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
//                   const SizedBox(height: 20),

//                   // Role Selector for email signup only
//                   const Text(
//                     "Select Role",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.textColor,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   RoleSelector(
//                     selectedRole: selectedRole,
//                     onSelect: (role) => setState(() => selectedRole = role),
//                   ),
//                   const SizedBox(height: 30),

//                   // Email Sign Up Button
//                   CustomButton(
//                     text: "Sign Up",
//                     onPressed: () async {
//                       if (selectedRole == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Please select your role first")),
//                         );
//                         return;
//                       }

//                       final error = await authProvider.signUp(
//                         _nameController.text.trim(),
//                         _emailController.text.trim(),
//                         _passwordController.text.trim(),
//                         selectedRole!,
//                       );

//                       if (error == null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Signup successful")),
//                         );
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                                       builder: (_) => ProfileSetupScreen(role: selectedRole![0].toUpperCase() + selectedRole!.substring(1).toLowerCase()),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(error)),
//                         );
//                       }
//                     },
//                   ),

//                   const SizedBox(height: 25),

      
//                   // Google Sign-Up Button
// ElevatedButton.icon(
//   style: ElevatedButton.styleFrom(
//     backgroundColor: Colors.white,
//     foregroundColor: Colors.black,
//     minimumSize: const Size(double.infinity, 50),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     side: const BorderSide(color: Colors.grey),
//     elevation: 3,
//     shadowColor: Colors.black26,
//   ),
//   onPressed: () async {
//     setState(() => authProvider.setLoading(true));

//     try {
//       final googleUser = await authProvider.signInWithGoogle(context);

//       if (googleUser != null) {
//         // Existing user → redirect to home or profile setup if needed
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Welcome back! You are already registered.")),
//         );

//         // Example: navigate to home screen (replace with your home)
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (_) => HomeScreen()),
//         // );
//       } 
//       // New Google user → RoleSelectionScreen is already pushed by AuthService
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error signing in with Google: $e")),
//       );
//     } finally {
//       setState(() => authProvider.setLoading(false));
//     }
//   },
//   icon: Image.network(
//     'https://developers.google.com/identity/images/g-logo.png',
//     height: 24,
//   ),
//   label: const Text(
//     "Sign up with Google",
//     style: TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.w500,
//     ),
//   ),
// ),


//                   const SizedBox(height: 25),

//                   // Already have account
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("Already have an account? "),
//                       TextButton(
//                         onPressed: () => Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const LoginScreen(),
//                           ),
//                         ),
//                         child: const Text(
//                           "Login",
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

//         // Loading overlay
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
//correct code above//
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/profile_setup_screen.dart';
// import 'package:provider/provider.dart';
// import '../../utils/app_theme.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/role_selector.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String? selectedRole;
//   bool _obscure = true;

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
//                   "Create Your Account",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Create an account to manage your profile",
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
//                             controller: _nameController,
//                             hintText: "Full Name",
//                             prefixIcon: Icons.person_outline,
//                           ),
//                           const SizedBox(height: 16),
//                           CustomTextField(
//                             controller: _emailController,
//                             hintText: "Email",
//                             prefixIcon: Icons.email_outlined,
//                           ),
//                           const SizedBox(height: 16),
//                           CustomTextField(
//                             controller: _passwordController,
//                             hintText: "Password",
//                             prefixIcon: Icons.lock_outline,
//                             obscureText: _obscure,
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                   _obscure ? Icons.visibility_off : Icons.visibility),
//                               onPressed: () => setState(() => _obscure = !_obscure),
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           const Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               "Select Role",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: AppTheme.textColor,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           RoleSelector(
//                             selectedRole: selectedRole,
//                             onSelect: (role) => setState(() => selectedRole = role),
//                           ),
//                           const SizedBox(height: 30),

//                           CustomButton(
//                             text: "Sign Up",
//                             onPressed: () async {
//                               if (selectedRole == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text("Please select your role first")),
//                                 );
//                                 return;
//                               }

//                               final error = await authProvider.signUp(
//                                 _nameController.text.trim(),
//                                 _emailController.text.trim(),
//                                 _passwordController.text.trim(),
//                                 selectedRole!,
//                               );

//                               if (error == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text("Signup successful")),
//                                 );
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ProfileSetupScreen(
//                                       role: selectedRole![0].toUpperCase() +
//                                           selectedRole!.substring(1).toLowerCase(),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text(error)),
//                                 );
//                               }
//                             },
//                           ),

//                           const SizedBox(height: 25),
//                           const Text("Sign Up With"),
//                           const SizedBox(height: 15),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               _socialButton('https://cdn-icons-png.flaticon.com/512/124/124010.png'),
//                               const SizedBox(width: 20),
//                               _socialButton('https://developers.google.com/identity/images/g-logo.png'),
//                               const SizedBox(width: 20),
//                               _socialButton('https://cdn-icons-png.flaticon.com/512/0/747.png'),
//                             ],
//                           ),
//                           const SizedBox(height: 30),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text("Already have an account? "),
//                               TextButton(
//                                 onPressed: () => Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const LoginScreen(),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Login",
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

//   Widget _socialButton(String imageUrl) {
//     return CircleAvatar(
//       radius: 22,
//       backgroundColor: Colors.white,
//       child: Image.network(imageUrl, height: 26),
//     );
//   }
// }
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
