
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';
import '../../utils/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle, color: AppTheme.primaryColor),
            title: Text(user?.name ?? "Unknown User"),
            subtitle: Text(user?.email ?? "No email"),
          ),
          const Divider(),

          // Working Dark Mode toggle
          SwitchListTile(
            value: themeProvider.isDark,
            onChanged: (val) async {
              await themeProvider.toggleTheme(val);
            },
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode, color: Colors.orange),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.blue),
            title: const Text("Help & Support"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Help & Support"),
                  content: const Text(
                    "For any support, please contact our team at:\n\nsupport@influencermarket.com",
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
