import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../constants/active_constants.dart';

class PhotoViewScreen extends StatelessWidget {
  final String image;
  const PhotoViewScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(appName),
        ),
        body : Container(child: PhotoView(imageProvider: NetworkImage(image)))
    );
  }
}
