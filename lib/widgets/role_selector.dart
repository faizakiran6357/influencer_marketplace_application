import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class RoleSelector extends StatelessWidget {
  final String? selectedRole;
  final Function(String) onSelect;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final roles = ['Influencer', 'Brand'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: roles.map((role) {
        final isSelected = role == selectedRole;
        return GestureDetector(
          onTap: () => onSelect(role),
          child: Container(
            width: 130,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.hintColor.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Column(
              children: [
                Icon(
                  role == 'Influencer' ? Icons.star_border : Icons.business,
                  color: isSelected ? Colors.white : AppTheme.textColor,
                ),
                const SizedBox(height: 6),
                Text(
                  role,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
