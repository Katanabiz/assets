import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageGridScreen extends StatelessWidget {
  final List<AssetEntity> images;

  const ImageGridScreen({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, images[index]);
            },
            child: Image(
              image: AssetEntityImageProvider(
                images[index],
                isOriginal: false,
              ),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
