import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_view/image_view.dart';
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

  Future<void> _cropImage(String filePath) async {
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

    try {
      if (croppedFile != null) {
        final croppedEntity = await PhotoManager.editor.saveImage(
          File(croppedFile.path).readAsBytesSync(),
          title: 'write_your_own_title.jpg',
        );

        if (croppedEntity != null) {
          setState(() {
            _assetEntity = croppedEntity;
          });
          navigateToDisplayImageScreen(croppedEntity);
        } else {
          print("cropped entity is null");
        }
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void navigateToDisplayImageScreen(AssetEntity assetEntity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayImageScreen(assetEntity: assetEntity),
      ),
    );
  }

  void _selectImageFromGallery() async {
    final List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(onlyAll: true);
    final AssetPathEntity album = albums.first;
    final List<AssetEntity> images =
        await album.getAssetListPaged(page: 0, size: 60);

    if (images.isNotEmpty) {
      final selectedImage = await imageGridMethod(images) as AssetEntity?;

      if (selectedImage != null) {
        final file = await selectedImage.file;
        _cropImage(file!.path);
      }
    }
  }

  Future<dynamic> imageGridMethod(List<AssetEntity> images) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageGridScreen(images: images),
      ),
    );
  }

  void _openCamera(BuildContext context) async {
    final cameraImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (cameraImage != null) {
      _cropImage(cameraImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker and Cropper'),
        ),
        body: _uploaderCard());
  }

  Widget _uploaderCard() {
    return ScaleTap(
      onPressed: () {
        _showBottomSheet(context);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DottedBorder(
              radius: const Radius.circular(12.0),
              borderType: BorderType.RRect,
              dashPattern: const [8, 4],
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.blue,
                      size: 80.0,
                    ),
                    Text('Upload an image to start',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            height: 150.0,
            decoration: const BoxDecoration(
              color: Colors.white, // Background color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            _selectImageFromGallery();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.photo_library,
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                        const Text('Gallery'),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            _openCamera(context);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.photo_camera,
                            color: Colors.blue,
                            size: 40.0,
                          ),
                        ),
                        const Text('Camera'),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
