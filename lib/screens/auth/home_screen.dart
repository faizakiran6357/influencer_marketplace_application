import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.celebration, size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: 24),
              Text(
                'Welcome, ${user?.email ?? "User"}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '🎉 You have successfully logged in.\nThis is a placeholder home screen.\nIn upcoming modules, dashboards will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
