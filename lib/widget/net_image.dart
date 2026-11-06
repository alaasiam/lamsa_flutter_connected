import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:souqna_anaqa/utils/app_colors.dart';
import 'package:souqna_anaqa/widget/loading.dart';

/// صورة من الإنترنت مع تخزين مؤقت وهيكل تحميل لطيف.
class NetImage extends StatelessWidget {
  const NetImage(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  final String? url;
  final BoxFit fit;
  final double radius;
  final double? width;
  final double? height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: AppColors.sand,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: AppColors.subtle),
    );
    final Widget imageWidget;
    if (url == null || url!.isEmpty) {
      imageWidget = placeholder;
    } else if (kIsWeb) {
      // على الويب: صور /uploads على الخادم بلا ترويسة CORS فيفشل جلبها كبايتات؛
      // fallback يعرضها كعنصر <img> عادي، والمتصفح يتولى التخزين المؤقت.
      imageWidget = Image.network(
        url!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : Skeleton(width: width, height: height),
        errorBuilder: (_, _, _) => placeholder,
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (_, _) => Skeleton(width: width, height: height),
        errorWidget: (_, _, _) => placeholder,
      );
    }

    final Widget content = (width == null && height == null)
        ? SizedBox.expand(child: imageWidget)
        : imageWidget;

    return radius == 0
        ? content
        : ClipRRect(borderRadius: BorderRadius.circular(radius), child: content);
  }
}
