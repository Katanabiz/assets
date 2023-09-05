import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_view/media_picker.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.croppedFile});
  final File? croppedFile;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<AssetEntity> sellectedAssetList = [];
    



  Future<void> pickAssets({
    required int maxCount,
    required RequestType requestType,
    required BuildContext context,
  }) async {
    final result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MediaPicker(maxCount, requestType);
    }));
    if (result != null) {
      setState(() {
        sellectedAssetList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (BuildContext innerContext) {
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Advanced Image Picker'),
              ),
              body: GridView.builder(
                  itemCount: sellectedAssetList.length,
                  itemBuilder: (context, index) {
                    AssetEntity assetEntity = sellectedAssetList[index];
                    return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: AssetEntityImage(
                                assetEntity,
                                isOriginal: false,
                                thumbnailSize: const ThumbnailSize.square(1000),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red));
                                },
                              ),
                            ),
                          ],
                        ));
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  )),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    print("Context 5555555555555: $context");

                    pickAssets(
                        context: innerContext,
                        maxCount: 1,
                        requestType: RequestType.common);
                  },
                  child: const Icon(Icons.add))),
        );
      }),
    );
  }
}
