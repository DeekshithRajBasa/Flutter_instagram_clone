import 'package:flutter/material.dart';

class InstagramImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? placeholderText;

  const InstagramImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderText,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: borderRadius,
          ),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Aesthetic Instagram fallback container
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF833AB4),
                Color(0xFFFD1D1D),
                Color(0xFFFCB045),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: borderRadius,
          ),
          child: Center(
            child: placeholderText != null && placeholderText!.isNotEmpty
                ? Text(
                    placeholderText![0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                : const Icon(
                    Icons.camera_alt,
                    color: Colors.white70,
                    size: 28,
                  ),
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}
