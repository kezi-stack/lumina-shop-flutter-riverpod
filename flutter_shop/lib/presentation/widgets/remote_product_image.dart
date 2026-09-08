import 'package:flutter/material.dart';

class RemoteProductImage extends StatelessWidget {
  const RemoteProductImage({
    required this.url,
    this.borderRadius = 20,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String url;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9EFE9),
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported_outlined, size: 32),
          );
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFE9EFE9),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}