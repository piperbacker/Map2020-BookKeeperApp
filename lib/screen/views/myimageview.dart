import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyImageView {
  static CachedNetworkImage network(
          {@required String imageURL, @required BuildContext context}) =>
      CachedNetworkImage(
        imageUrl: imageURL ??
            'https://firebasestorage.googleapis.com/v0/b/piper-map2020-bookkeeperapp.appspot.com/o/DefaultProfilePicture%2Fdef_profile.png?alt=media&token=0fdeb013-fdcb-413a-9946-e6653cbc241f',
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
