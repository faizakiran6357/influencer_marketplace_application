
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/auth_provider.dart';
// import '../../../providers/brand_provider.dart';
// import '../../../utils/app_theme.dart';
// import '../profile/edit_brand_profile.dart';

// class BrandProfileScreen extends StatefulWidget {
//   const BrandProfileScreen({super.key});

//   @override
//   State<BrandProfileScreen> createState() => _BrandProfileScreenState();
// }

// class _BrandProfileScreenState extends State<BrandProfileScreen> {
//   bool _isLoggingOut = false;

//   @override
//   Widget build(BuildContext context) {
//     final brandProvider = context.watch<BrandProvider>();
//     final brand = brandProvider.brand;
//     final authProvider = context.read<AuthProvider>();

//     if (brand == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // 🌈 Subtle Curved Gradient Header
//             Stack(
//               children: [
//                 ClipPath(
//                   clipper: _CurvedHeaderClipper(),
//                   child: Container(
//                     height: 250,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppTheme.primaryColor,
//                           AppTheme.primaryColor.withOpacity(0.85),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CircleAvatar(
//                             radius: 45,
//                             backgroundImage: brand.profileImage != null &&
//                                     brand.profileImage!.isNotEmpty
//                                 ? NetworkImage(brand.profileImage!)
//                                 : const AssetImage(
//                                         'assets/images/default_avatar.png')
//                                     as ImageProvider,
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   brand.name ?? "Brand Name",
//                                   style: const TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   brand.email ?? "example@brand.com",
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white70,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 ElevatedButton.icon(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => const EditBrandProfile(),
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     foregroundColor: AppTheme.primaryColor,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     minimumSize: const Size(0, 36),
//                                   ),
//                                   icon: const Icon(Icons.edit, size: 18),
//                                   label: const Text(
//                                     "Edit Profile",
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 20),

//             // 🔹 Combined About Card (Brand + App)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // About Brand
//                       const Text(
//                         "About Our Brand",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: AppTheme.primaryColor,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         brand.bio?.isNotEmpty == true
//                             ? brand.bio!
//                             : "You haven't added a bio yet. Tell influencers about your brand’s vision and values!",
//                         style: const TextStyle(
//                           fontSize: 15,
//                           color: Colors.black87,
//                           height: 1.4,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.language, color: AppTheme.primaryColor),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               brand.website?.isNotEmpty == true
//                                   ? brand.website!
//                                   : "No website added",
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.black87,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),

//                       // const SizedBox(height: 20),
//                       // const Divider(),
//                       // const SizedBox(height: 12),

//                       // // About App Section
//                       // const Text(
//                       //   "About App",
//                       //   style: TextStyle(
//                       //     fontSize: 18,
//                       //     fontWeight: FontWeight.bold,
//                       //     color: AppTheme.primaryColor,
//                       //   ),
//                       // ),
//                       // const SizedBox(height: 10),
//                       // const Text(
//                       //   "Influencer Marketplace connects brands with influencers to create impactful collaborations and campaigns.",
//                       //   style: TextStyle(
//                       //     fontSize: 15,
//                       //     color: Colors.black87,
//                       //     height: 1.4,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//              const SizedBox(height: 20),
//                       const Divider(),
//                       const SizedBox(height: 12),

//             // 🔹 Logout
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.redAccent),
//               title: const Text(
//                 "Logout",
//                 style: TextStyle(fontSize: 16),
//               ),
//               onTap: _isLoggingOut
//                   ? null
//                   : () async {
//                       final shouldLogout = await showDialog<bool>(
//                             context: context,
//                             builder: (ctx) => AlertDialog(
//                               title: const Text("Logout"),
//                               content: const Text("Are you sure you want to log out?"),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(ctx, false),
//                                   child: const Text("Cancel"),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () => Navigator.pop(ctx, true),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.redAccent,
//                                   ),
//                                   child: const Text("Logout"),
//                                 ),
//                               ],
//                             ),
//                           ) ??
//                           false;

//                       if (!shouldLogout) return;

//                       setState(() => _isLoggingOut = true);

//                       try {
//                         await authProvider.logout();

//                         if (!mounted) return;

//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           '/login',
//                           (route) => false,
//                         );
//                       } catch (e) {
//                         if (mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Logout failed: $e")),
//                           );
//                         }
//                       } finally {
//                         if (mounted) {
//                           setState(() => _isLoggingOut = false);
//                         }
//                       }
//                     },
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 🌊 Subtle Curved Header Clipper
// class _CurvedHeaderClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height - 30);
//     path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/brand_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/app_theme.dart';
import '../profile/edit_brand_profile.dart';

class BrandProfileScreen extends StatefulWidget {
  const BrandProfileScreen({super.key});

  @override
  State<BrandProfileScreen> createState() => _BrandProfileScreenState();
}

class _BrandProfileScreenState extends State<BrandProfileScreen> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final brandProvider = context.watch<BrandProvider>();
    final brand = brandProvider.brand;
    final authProvider = context.read<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;
    final primary = AppTheme.primaryColor;

    if (brand == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 🌈 Modern Gradient Header with Glassmorphism
            Stack(
              children: [
                ClipPath(
                  clipper: _CurvedHeaderClipper(),
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary.withOpacity(0.85),
                          primary.withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Decorative circles
                Positioned(
                  top: 40,
                  right: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar with gradient ring
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundImage: brand.profileImage != null &&
                                      brand.profileImage!.isNotEmpty
                                  ? NetworkImage(brand.profileImage!)
                                  : null,
                              backgroundColor: Colors.white,
                              child: brand.profileImage == null ||
                                      brand.profileImage!.isEmpty
                                  ? Icon(
                                      LucideIcons.building2,
                                      size: 48,
                                      color: primary,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brand.name.isNotEmpty
                                      ? brand.name
                                      : "Brand Name",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.mail,
                                      size: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        brand.email.isNotEmpty
                                            ? brand.email
                                            : "example@brand.com",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const EditBrandProfile(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: primary,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    icon: const Icon(
                                      LucideIcons.edit3,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔹 Modern Brand Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              LucideIcons.info,
                              size: 20,
                              color: primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "About Our Brand",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        brand.bio?.isNotEmpty == true
                            ? brand.bio!
                            : "You haven't added a bio yet. Tell influencers about your brand's vision and values!",
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.grey.shade300 : Colors.black87,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                LucideIcons.globe,
                                size: 18,
                                color: primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Website",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    brand.website?.isNotEmpty == true
                                        ? brand.website!
                                        : "No website added",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Modern Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade600,
                      Colors.red.shade500,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _isLoggingOut
                      ? null
                      : () async {
                          final shouldLogout = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor:
                                      isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                  title: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          LucideIcons.logOut,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    "Are you sure you want to log out?",
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: isDark
                                          ? Colors.grey.shade300
                                          : Colors.black87,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade600,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;

                          if (!shouldLogout) return;

                          setState(() => _isLoggingOut = true);

                          try {
                            await authProvider.logout();

                            if (!mounted) return;

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Logout failed: $e"),
                                  backgroundColor: Colors.red.shade600,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoggingOut = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: _isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          LucideIcons.logOut,
                          color: Colors.white,
                          size: 20,
                        ),
                  label: Text(
                    _isLoggingOut ? "Logging out..." : "Logout",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 🌊 Modern Curved Header Clipper
class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

