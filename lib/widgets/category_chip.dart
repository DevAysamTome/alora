import 'package:flutter/material.dart';
import '../data/models/category.dart';

class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) => onTap(),
        selectedColor: Colors.blueAccent,
        backgroundColor: Colors.grey.shade200,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade400,
            width: 1.0,
          ),
        ),
        elevation: 2,
        pressElevation: 4,
      ),
    );
  }
}
