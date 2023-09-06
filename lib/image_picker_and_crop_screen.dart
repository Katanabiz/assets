import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_view/mainold.dart';
import 'package:photo_manager/photo_manager.dart';

class ImagePickerAndCropperScreen extends StatefulWidget {
  const ImagePickerAndCropperScreen({Key? key}) : super(key: key);

  @override
  ImagePickerAndCropperScreenState createState() =>
      ImagePickerAndCropperScreenState();
}

class ImagePickerAndCropperScreenState
    extends State<ImagePickerAndCropperScreen> {
  AssetEntity? _assetEntity;

  Future<void> _cropImage(BuildContext context, String filePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      final croppedEntity = await PhotoManager.editor.saveImage(
          File(croppedFile.path).readAsBytesSync(),
          title: 'Cropped Image');
      setState(() {
        _assetEntity = croppedEntity;
      });
    }
  }

  void _selectImageFromGallery(BuildContext context) async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(onlyAll: true);
    final AssetPathEntity album = albums.first;
    final List<AssetEntity> images =
        await album.getAssetListPaged(page: 0, size: 60);

    if (images.isNotEmpty) {
      final selectedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageGridScreen(images: images),
        ),
      ) as AssetEntity?;

      if (selectedImage != null) {
        final file = await selectedImage.file;
        _cropImage(context, file!.path);
      }
    }
  }

  void _openCamera(BuildContext context) async {
    final cameraImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (cameraImage != null) {
      _cropImage(context, cameraImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker and Cropper'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_assetEntity != null)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 0.8 * screenWidth,
                  maxHeight: 0.7 * screenHeight,
                ),
                child: Image(
                  image: AssetEntityImageProvider(
                    thumbnailSize: const ThumbnailSize(200, 200),
                    _assetEntity!,
                    isOriginal: true,
                  ),
                
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectImageFromGallery(context),
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () => _openCamera(context),
              child: const Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
