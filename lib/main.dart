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
  const MyApp({
    super.key, this.croppedFile,
  });
 final   File? croppedFile;

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
              body: Column(
                children: [
                  Center(
                    child: widget.croppedFile != null
                        ? Image.file(widget.croppedFile!,
                            fit: BoxFit.cover, height: 300, width: 300)
                        : const Text('No file selected'),
                  ),
                ],
              ),
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
