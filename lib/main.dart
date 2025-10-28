
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:provider/provider.dart';
// import 'utils/app_theme.dart';
// import 'providers/auth_provider.dart';

// void main() {
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
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       home: const SplashScreen(),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:provider/provider.dart';
// import 'utils/app_theme.dart';
// import 'providers/auth_provider.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SupabaseAuthService.initialize();

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
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       home: const SplashScreen(),
//     );
//   }
// }
// correct//
import 'package:flutter/material.dart';
import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
import 'package:influencer_marketplace_application/screens/auth/home_screen.dart';
import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
import 'package:influencer_marketplace_application/services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'utils/app_theme.dart';

// 👇 Global navigator key (for navigation outside BuildContext)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Supabase (your custom service)
  await SupabaseAuthService.initialize();

  // 👇 Listen for Supabase auth state changes
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;

    // ✅ When user clicks "reset password" email link
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
      ],
      child: const InfluencerApp(),
    ),
  );
}

class InfluencerApp extends StatelessWidget {
  const InfluencerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 👈 Attach global key here
      debugShowCheckedModeBanner: false,
      title: 'Influencer Marketplace',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
