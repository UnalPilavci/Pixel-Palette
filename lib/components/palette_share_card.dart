import 'dart:io';
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/color_utils.dart';

class PaletteShareCard extends StatelessWidget {
  final File imageFile;
  final List<Color> colors;

  const PaletteShareCard({
    super.key,
    required this.imageFile,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Renk Paleti",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: colors.map((color) => _buildColorBox(color)).toList(),
          ),
          const SizedBox(height: 30),
          Text("Color Hunter ile oluşturuldu", style: TextStyle(color: Colors.grey[600], fontSize: 12))
        ],
      ),
    );
  }
  Widget _buildColorBox(Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 5, offset: const Offset(0, 3))
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Hex Kodu
        Text(
          ColorUtils.toHex(color),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}