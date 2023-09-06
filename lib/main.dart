import 'package:flutter/material.dart';
import 'package:image_view/image_picker_and_crop_screen.dart';

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
