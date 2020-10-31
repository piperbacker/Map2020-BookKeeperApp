import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyImageView {
  static CachedNetworkImage network(
          {@required String imageURL, @required BuildContext context}) =>
      CachedNetworkImage(
        imageUrl: imageURL ?? 'http://noadress',
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 30.0,
        ),
        progressIndicatorBuilder: (context, url, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
        ),
      );
}
