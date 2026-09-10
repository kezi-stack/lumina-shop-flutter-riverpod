import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      child: SvgPicture.asset(
        url,
        fit: fit,
        placeholderBuilder: (context) => Container(
          color: const Color(0xFFE9EFE9),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}
