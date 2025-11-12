import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final List<String> items;
  final void Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      style: TextStyle(
        fontSize: isSmallScreen ? 14 : 16,
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white 
            : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
        prefixIcon: Icon(icon, size: isSmallScreen ? 18 : 20),
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 12 : 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      )).toList(),
      onChanged: onChanged,
    );
  }
}