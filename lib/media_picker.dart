import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_view/mainold.dart';
import 'package:image_view/media_services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_cropper/image_cropper.dart';

class MediaPicker extends StatefulWidget {
  const MediaPicker(this.maxCount, this.requestType, {super.key});

  final int maxCount;
  final RequestType requestType;

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? selectedAlbum;
  List<AssetEntity> assetList = [];
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> selectedAssetList = [];
  List<File> fileList = [];
  File? _croppedFile;

  @override
  void initState() {
    MediaServices().loadAlbums(widget.requestType).then((value) {
      setState(() {
        albumList = value;
        selectedAlbum = value[0];
      });

      MediaServices().loadAssets(selectedAlbum!).then((value) {
        setState(() {
          assetList = value;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: DropdownButton<AssetPathEntity>(
          value: selectedAlbum,
          onChanged: (AssetPathEntity? newValue) {
            setState(() {
              selectedAlbum = newValue;
            });
            MediaServices().loadAssets(selectedAlbum!).then((value) {
              setState(() {
                assetList = value;
              });
            });
          },
          items: albumList.map((AssetPathEntity album) {
            print("2222222 22 222222 ${album.name.length}");
            return DropdownMenuItem<AssetPathEntity>(
              value: album,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Count: ${album.assetCount}",
                  ),

                  // Add more information about the album here
                ],
              ),
            );
          }).toList(),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              for (var asset in selectedAssetList) {
                await _cropImage(asset);
              }
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ),
      body: assetList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: assetList.length,
              itemBuilder: (context, index) {
                AssetEntity assetEntity = assetList[index];
                return GestureDetector(
                    onTap: () {
                      selectAsset(assetEntity: assetEntity);
                    },
                    child: Container(
                        color: const Color(0xff1E2734),
                        child: assetBuilder(assetEntity)));
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              )),
    ));
  }

  Widget assetBuilder(AssetEntity assetEntity) => Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(
                  selectedAssetList.contains(assetEntity) == true ? 15 : 0),
              child: AssetEntityImage(
                assetEntity,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(250),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.error, color: Colors.red));
                },
              ),
            ),
          ),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        selectAsset(assetEntity: assetEntity);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                            decoration: BoxDecoration(
                                color:
                                    selectedAssetList.contains(assetEntity) ==
                                            true
                                        ? Colors.blue
                                        : Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 1.5)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                  selectedAssetList.contains(assetEntity) ==
                                          true
                                      ? '${selectedAssetList.indexOf(assetEntity) + 1}'
                                      : '',
                                  style: TextStyle(
                                      color: selectedAssetList
                                                  .contains(assetEntity) ==
                                              true
                                          ? Colors.white
                                          : Colors.transparent)),
                            )),
                      ))))
        ],
      );
  void selectAsset({required AssetEntity assetEntity}) {
    if (selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else {
      if (selectedAssetList.length < widget.maxCount) {
        setState(() {
          selectedAssetList.add(assetEntity);
        });
      }
    }
  }

  Future<void> _cropImage(AssetEntity assetEntity) async {
    File? tempFile = await assetEntity.file;
    if (tempFile != null) {
        final croppedFile = await ImageCropper().cropImage(
        sourcePath: tempFile.path,
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
        setState(() {
          _croppedFile = File(croppedFile.path);
        });
        navigatorMethod();
      }
    }
  }

  void navigatorMethod() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => MyApp(croppedFile: _croppedFile)),
    // ).then((_) {
    //   Navigator.pop(context, selectedAssetList);
    // });
  }
}
