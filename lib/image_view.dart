import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DisplayImageScreen extends StatelessWidget {
  final AssetEntity? assetEntity;

  const DisplayImageScreen({Key? key, required this.assetEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Image'),
      ),
      body: Center(
        child: assetEntity != null
            ? Image(
                image: AssetEntityImageProvider(
                  thumbnailSize: const ThumbnailSize(200, 200),
                  assetEntity!,
                  isOriginal: true,
                ),
              )
            : const Text('No image selected'),
      ),
    );
  }
}
