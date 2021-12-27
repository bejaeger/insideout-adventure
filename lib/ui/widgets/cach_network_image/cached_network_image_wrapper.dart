import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWrapper extends StatelessWidget {
  final String imageUrl;
  final Widget? loader;
  final Widget? errorWidget;

  const CachedNetworkImageWrapper(
      {Key? key, required this.imageUrl, this.loader, this.errorWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (BuildContext context, String url) =>
          loader ??
          Center(
            child: CircularProgressIndicator(),
          ),
      errorWidget: (BuildContext context, String url, dynamic error) =>
          errorWidget ?? Image.asset('assets/icons/sem-internet.jpg'),
      fit: BoxFit.fill,
    );
  }
}
