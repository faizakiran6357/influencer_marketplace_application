import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/brand_provider.dart';
import 'edit_brand_profile.dart';

class BrandProfileScreen extends StatelessWidget {
  const BrandProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BrandProvider>();
    final brand = provider.brand;

    if (brand == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Brand Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: brand.profileImage != null ? NetworkImage(brand.profileImage!) : null,
              child: brand.profileImage == null ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 16),
            Text(brand.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(brand.bio ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(brand.website ?? '', style: const TextStyle(fontSize: 16, color: Colors.blue)),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Edit Profile"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const EditBrandProfile()));
              },
            )
          ],
        ),
      ),
    );
  }
}
