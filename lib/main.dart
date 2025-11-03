
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
// import 'package:influencer_marketplace_application/screens/auth/home_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'providers/auth_provider.dart';
// import 'utils/app_theme.dart';

// // 👇 Global navigator key (for navigation outside BuildContext)
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // initialize Supabase (your custom service)
//   await SupabaseAuthService.initialize();

//   // 👇 Listen for Supabase auth state changes
//   Supabase.instance.client.auth.onAuthStateChange.listen((data) {
//     final AuthChangeEvent event = data.event;

//     // ✅ When user clicks "reset password" email link
//     if (event == AuthChangeEvent.passwordRecovery) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
//       );
//     }
//   });

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ],
//       child: const InfluencerApp(),
//     ),
//   );
// }

// class InfluencerApp extends StatelessWidget {
//   const InfluencerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey, // 👈 Attach global key here
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       home: const SplashScreen(),
//     routes: {
//         '/login': (context) => const LoginScreen(),
//         '/home': (context) => const HomeScreen(),
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'providers/auth_provider.dart';
// import 'utils/app_theme.dart';

// // 🧭 Global navigator key for navigation outside BuildContext
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Supabase
//   await SupabaseAuthService.initialize();

//   // Listen for Supabase auth state changes (e.g. password reset)
//   Supabase.instance.client.auth.onAuthStateChange.listen((data) {
//     final AuthChangeEvent event = data.event;

//     // ✅ Handle password recovery link
//     if (event == AuthChangeEvent.passwordRecovery) {
//       navigatorKey.currentState?.push(
//         MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
//       );
//     }
//   });

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//           ChangeNotifierProvider(create: (_) => InfluencerProvider()),
//       ],
//       child: const InfluencerApp(),
//     ),
//   );
// }

// class InfluencerApp extends StatelessWidget {
//   const InfluencerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       home: const SplashScreen(),

//       // 🔒 Only include auth-related routes
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/reset-password': (context) => const ResetPasswordScreen(),
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/providers/brand_provider.dart';
import 'package:influencer_marketplace_application/providers/chat_provider.dart';
import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:influencer_marketplace_application/providers/auth_provider.dart';
import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
import 'package:influencer_marketplace_application/providers/theme_provider.dart';
import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
import 'package:influencer_marketplace_application/services/auth_service.dart';
import 'package:influencer_marketplace_application/utils/app_theme.dart';

// 🧭 Global navigator key for navigation outside BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseAuthService.initialize();

  // Listen for Supabase auth state changes (for password reset)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;

    // ✅ Handle password recovery link
    if (event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InfluencerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()), 
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const InfluencerApp(),
    ),
  );
}

class InfluencerApp extends StatelessWidget {
  const InfluencerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Influencer Marketplace',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light, // ✅ Dynamic mode
      home: const SplashScreen(),

      // Auth-related routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
