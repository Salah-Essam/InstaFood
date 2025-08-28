import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class CachedImage extends StatelessWidget {
  final double? height;
  final double? width;
  const CachedImage({super.key, required this.item, this.height, this.width});

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheKey: item.imageUrl,
      imageUrl: item.imageUrl,
      placeholder: (context, url) =>
          Center(child: const CircularProgressIndicator()),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => SizedBox.expand(
        child: Container(
          color: Colors.grey[300],
          child: Icon(Icons.error_outline, color: Colors.grey[500]),
        ),
      ),
    );
  }
}
