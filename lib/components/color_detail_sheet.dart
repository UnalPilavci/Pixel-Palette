import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_theme.dart';
import '../utils/color_utils.dart';

class ColorDetailSheet extends StatelessWidget {
  final Color color;

  const ColorDetailSheet({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ColorUtils.toHex(color),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text("Renk Detayları", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          _buildInfoRow(context, "RGB", ColorUtils.toRGB(color), Icons.monitor),
          _buildInfoRow(context, "CMYK", ColorUtils.toCMYK(color), Icons.print),
          _buildInfoRow(context, "HSL", ColorUtils.toHSL(color), Icons.color_lens),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$label kopyalandı: $value"),
                  backgroundColor: AppTheme.primary,
                  duration: const Duration(seconds: 1),
                ),
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}