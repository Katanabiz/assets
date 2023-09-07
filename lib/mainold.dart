// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_view/media_picker.dart';
// import 'package:photo_manager/photo_manager.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({
//     super.key, this.croppedFile,
//   });
//  final   File? croppedFile;

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<AssetEntity> sellectedAssetList = [];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Builder(builder: (BuildContext innerContext) {
//         return SafeArea(
//           child: Scaffold(
//               appBar: AppBar(
//                 title: const Text('Advanced Image Picker'),
//               ),
//               body: Column(
//                 children: [
//                   Center(
//                     child: widget.croppedFile != null
//                         ? Image.file(widget.croppedFile!,
//                             fit: BoxFit.cover, height: 300, width: 300)
//                         : const Text('No file selected'),
//                   ),
//                 ],
//               ),
//               floatingActionButton: FloatingActionButton(
//                   onPressed: () {
//                     print("Context 5555555555555: $context");

//                     pickAssets(
//                         context: innerContext,
//                         maxCount: 1,
//                         requestType: RequestType.common);
//                   },
//                   child: const Icon(Icons.add))),
//         );
//       }),
//     );
//   }
// }

// import 'dart:io';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_view/media_picker.dart';
// import 'package:photo_manager/photo_manager.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//           highlightColor: const Color(0xFFD0996F),
//           canvasColor: const Color(0xFFFDF5EC),
//           textTheme: TextTheme(
//             headlineSmall: ThemeData.light()
//                 .textTheme
//                 .headlineSmall!
//                 .copyWith(color: const Color(0xFFBC764A)),
//           ),
//           iconTheme: IconThemeData(
//             color: Colors.grey[600],
//           ),
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Color(0xFFBC764A),
//             centerTitle: false,
//             foregroundColor: Colors.white,
//             actionsIconTheme: IconThemeData(color: Colors.white),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateColor.resolveWith(
//                   (states) => const Color(0xFFBC764A)),
//             ),
//           ),
//           outlinedButtonTheme: OutlinedButtonThemeData(
//             style: ButtonStyle(
//               foregroundColor: MaterialStateColor.resolveWith(
//                 (states) => const Color(0xFFBC764A),
//               ),
//               side: MaterialStateBorderSide.resolveWith(
//                   (states) => const BorderSide(color: Color(0xFFBC764A))),
//             ),
//           ),
//           colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
//               .copyWith(background: const Color(0xFFFDF5EC))),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   XFile? _pickedFile;
//   CroppedFile? _croppedFile;
//   File? croppedFile;
//   List<AssetEntity> sellectedAssetList = [];
//   late AssetEntity assetEntity;

//   Future<void> pickAssets({
//     required int maxCount,
//     required RequestType requestType,
//   }) async {
//     final result =
//         await Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return MediaPicker(maxCount, requestType);
//     }));
//     if (result != null) {
//       setState(() {
//         sellectedAssetList = result;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('picker image')),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(child: _body()),
//         ],
//       ),
//     );
//   }

//   Widget _body() {
//     if (_croppedFile != null || _pickedFile != null) {
//       return _imageCard();
//     } else {
//       return _uploaderCard();
//     }
//   }

//   Widget _imageCard() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
//             child: Card(
//               elevation: 4.0,
//               child: Padding(
//                 padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
//                 child: _image(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24.0),
//           _menu(),
//         ],
//       ),
//     );
//   }

//   Widget _image() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     if (_croppedFile != null) {
//       final path = _croppedFile!.path;
//       return ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 0.8 * screenWidth,
//           maxHeight: 0.7 * screenHeight,
//         ),
//         child: Image.file(File(path)),
//       );
//     } else if (_pickedFile != null) {
//       final path = _pickedFile!.path;
//       return ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 0.8 * screenWidth,
//           maxHeight: 0.7 * screenHeight,
//         ),
//         child: Image.file(File(path)),
//       );
//     } else if (assetEntity != null) {
//       final path = assetEntity.file;
//       return ConstrainedBox(
//         constraints: BoxConstraints(
//           maxWidth: 0.8 * screenWidth,
//           maxHeight: 0.7 * screenHeight,
//         ),
//         child: Image.file(File(path.toString())),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }

//   Widget _menu() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         FloatingActionButton(
//           onPressed: () {
//             _clear();
//           },
//           backgroundColor: Colors.redAccent,
//           tooltip: 'Delete',
//           child: const Icon(Icons.delete),
//         ),
//         if (_croppedFile == null)
//           Padding(
//             padding: const EdgeInsets.only(left: 32.0),
//             child: FloatingActionButton(
//               onPressed: () {
//                 _cropImage();
//               },
//               backgroundColor: const Color(0xFFBC764A),
//               tooltip: 'Crop',
//               child: const Icon(Icons.crop),
//             ),
//           )
//       ],
//     );
//   }

  // Widget _uploaderCard() {
  //   return Center(
  //     child: Card(
  //       elevation: 4.0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16.0),
  //       ),
  //       child: SizedBox(
  //         width: kIsWeb ? 380.0 : 320.0,
  //         height: 300.0,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.max,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: DottedBorder(
  //                   radius: const Radius.circular(12.0),
  //                   borderType: BorderType.RRect,
  //                   dashPattern: const [8, 4],
  //                   color: Theme.of(context).highlightColor.withOpacity(0.4),
  //                   child: Center(
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.image,
  //                           color: Theme.of(context).highlightColor,
  //                           size: 80.0,
  //                         ),
  //                         const SizedBox(height: 24.0),
  //                         Text(
  //                           'Upload an image to start',
  //                           style: kIsWeb
  //                               ? Theme.of(context)
  //                                   .textTheme
  //                                   .headlineSmall!
  //                                   .copyWith(
  //                                       color: Theme.of(context).highlightColor)
  //                               : Theme.of(context)
  //                                   .textTheme
  //                                   .bodyMedium!
  //                                   .copyWith(
  //                                       color:
  //                                           Theme.of(context).highlightColor),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 24.0),
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       pickAssets(
  //                           maxCount: 1, requestType: RequestType.common);
  //                     },
  //                     child: const Text('Upload'),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 24.0),
  //                   child: ElevatedButton(
  //                     onPressed: () {
  //                       _uploadImage();
  //                     },
  //                     child: const Text('Take a photo'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

// Future<void> _cropImage() async {
//   if (_pickedFile != null) {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: _pickedFile!.path,
//       compressFormat: ImageCompressFormat.jpg,
//       compressQuality: 100,
      // uiSettings: [
      //   AndroidUiSettings(
      //       toolbarTitle: 'Cropper',
      //       toolbarColor: Colors.deepOrange,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.original,
      //       lockAspectRatio: false),
      //   IOSUiSettings(
      //     title: 'Cropper',
      //   ),
      // ],
//     );
//     if (croppedFile != null) {
//       setState(() {
//         _croppedFile = croppedFile;
//       });
//     }
//   }
// }

//   Future<void> _uploadImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _pickedFile = pickedFile;
//       });
//     }
//   }

//   void _clear() {
//     setState(() {
//       _pickedFile = null;
//       _croppedFile = null;
//     });
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker and Cropper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImagePickerAndCropperScreen(),
    );
  }
}

class ImagePickerAndCropperScreen extends StatefulWidget {
  const ImagePickerAndCropperScreen({Key? key}) : super(key: key);

  @override
  _ImagePickerAndCropperScreenState createState() =>
      _ImagePickerAndCropperScreenState();
}

class _ImagePickerAndCropperScreenState
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker and Cropper'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_assetEntity != null)
            Image(
              image: AssetEntityImageProvider(
                _assetEntity!,
                isOriginal: false,
              ),
              width: 300,
              height: 300,
              fit: BoxFit.cover,
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
    );
  }
}

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
