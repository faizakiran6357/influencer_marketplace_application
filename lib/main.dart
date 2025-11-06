
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
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/brand_provider.dart';
// import 'package:influencer_marketplace_application/providers/chat_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
// import 'package:influencer_marketplace_application/providers/theme_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';

// // 🧭 Global navigator key for navigation outside BuildContext
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Supabase
//   await SupabaseAuthService.initialize();

//   // Listen for Supabase auth state changes (for password reset)
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
//         ChangeNotifierProvider(create: (_) => InfluencerProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => BrandProvider()), 
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//       ],
//       child: const InfluencerApp(),
//     ),
//   );
// }

// class InfluencerApp extends StatelessWidget {
//   const InfluencerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();

//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light, // ✅ Dynamic mode
//       home: const SplashScreen(),

//       // Auth-related routes
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/reset-password': (context) => const ResetPasswordScreen(),
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/brand_provider.dart';
// import 'package:influencer_marketplace_application/providers/chat_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
// import 'package:influencer_marketplace_application/providers/theme_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';

// // 🔔 Notification Service
// import 'package:influencer_marketplace_application/services/notification_service.dart';
// import 'firebase_options.dart';

// // 🧭 Global navigator key for navigation outside BuildContext
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Supabase
//   await SupabaseAuthService.initialize();

//   // Initialize Firebase for notifications
//   await NotificationService.initNotifications();

//   // Listen for Supabase auth state changes (for password reset)
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
//         ChangeNotifierProvider(create: (_) => InfluencerProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => BrandProvider()), 
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//       ],
//       child: const InfluencerApp(),
//     ),
//   );
// }

// class InfluencerApp extends StatelessWidget {
//   const InfluencerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();

//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
//       home: const SplashScreen(), // ✅ Keep SplashScreen as entry point

//       // Auth-related routes
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/reset-password': (context) => const ResetPasswordScreen(),
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:influencer_marketplace_application/providers/brand_provider.dart';
// import 'package:influencer_marketplace_application/providers/chat_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/ResetPasswordScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:influencer_marketplace_application/providers/auth_provider.dart';
// import 'package:influencer_marketplace_application/providers/influencer_provider.dart';
// import 'package:influencer_marketplace_application/providers/theme_provider.dart';
// import 'package:influencer_marketplace_application/screens/auth/login_screen.dart';
// import 'package:influencer_marketplace_application/screens/auth/splash_screen.dart';
// import 'package:influencer_marketplace_application/services/auth_service.dart';
// import 'package:influencer_marketplace_application/utils/app_theme.dart';

// // 🔔 Notification Service
// import 'package:influencer_marketplace_application/services/notification_service.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// // 🧭 Global navigator key for navigation outside BuildContext
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // 🔹 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('💬 Background Message: ${message.notification?.title}');
//   await NotificationService.showLocalNotification(message);
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Supabase
//   await SupabaseAuthService.initialize();

//   // Initialize Firebase
//   await Firebase.initializeApp();

//   // Set background FCM handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   // Initialize Notification Service
//   await NotificationService.initNotifications();

//   // Listen for Supabase auth state changes (for password reset)
//   Supabase.instance.client.auth.onAuthStateChange.listen((data) {
//     final AuthChangeEvent event = data.event;

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
//         ChangeNotifierProvider(create: (_) => InfluencerProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => BrandProvider()),
//         ChangeNotifierProvider(create: (_) => ChatProvider()),
//       ],
//       child: const InfluencerApp(),
//     ),
//   );
// }

// class InfluencerApp extends StatelessWidget {
//   const InfluencerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();

//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Influencer Marketplace',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
//       home: const SplashScreen(),
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/reset-password': (context) => const ResetPasswordScreen(),
//       },
//     );
//   }
// }
import 'dart:async';
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

// 🔔 Notification Service
import 'package:influencer_marketplace_application/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// 🧭 Global navigator key for navigation outside BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 🔹 Background FCM handler — MUST NOT call UI/local notification plugin here
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase in background isolate
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Already initialized or failed — just log
    debugPrint('⚠️ Firebase init in background failed/duplicate: $e');
  }

  // Handle data-only messages or log the payload.
  debugPrint('📩 [background] Message ID: ${message.messageId}');
  debugPrint('📩 [background] Data: ${message.data}');
  // IMPORTANT: Do NOT call FlutterLocalNotificationsPlugin here.
  // If you want to show a native notification from background,
  // include the "notification" payload on the server side (FCM),
  // and Android will display it automatically when app is backgrounded/terminated.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await Firebase.initializeApp();

  // Set background message handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Supabase (app's backend)
  await SupabaseAuthService.initialize();

  // Initialize Notification Service (local notifications + onMessage listeners)
  await NotificationService.initNotifications();

  // Listen for Supabase auth state changes (for password recovery)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    if (event == AuthChangeEvent.passwordRecovery) {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
      );
    }
  });

  // runApp inside guarded zone to catch uncaught errors
  runZonedGuarded(() {
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
  }, (error, stack) {
    debugPrint('🔥 Uncaught error: $error');
    debugPrint('$stack');
  });
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
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
