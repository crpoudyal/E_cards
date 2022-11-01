import 'dart:io';
import 'dart:typed_data';

import 'package:Ecards/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

abstract class EditImage extends State<HomeScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textEditingController = TextEditingController();

  String text = "";
  double top = 10;
  double left = 10;
  double finalAngle = 0.0;
  Color bgcolor = Colors.orange;
  Color txColor = Colors.white;

  // Handling Permission for Storage

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    statuses[Permission.storage].toString();
  }

  // Showing Captured Image

  Future<dynamic> showCapturedImage(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured Image"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            capturedImage != null ? Image.memory(capturedImage) : Container(),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  saveToGallery(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image is saved to gallery")));
                },
                child: const Text("Save to Gallery")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final Directory temp = await getTemporaryDirectory();
                final path = '${temp.path}/ecardimage.jpg';
                File(path).writeAsBytesSync(capturedImage.buffer.asUint8List());
                await Share.shareXFiles([XFile(path)]);
              },
              child: const Text("Share"),
            ),
          ],
        ),
      ),
    );
  }

  saveToGallery(BuildContext context) {
    screenshotController
        .capture()
        .then((Uint8List? image) => saveImage(image!));
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    print('time -- $time');
    final name = "Ecards_$time";
    await _requestPermission();
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  void pickBgColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick color for Background"),
            content: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildBgColorPicker(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "SELECT",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ));

  void pickTxColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick color for Text"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTxColorPicker(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "SELECT",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ));

  Widget buildBgColorPicker() {
    return ColorPicker(
        pickerColor: bgcolor,
        onColorChanged: (color) {
          setState(() {
            bgcolor = color;
          });
        });
  }

  Widget buildTxColorPicker() {
    return ColorPicker(
        pickerColor: txColor,
        onColorChanged: (color) {
          setState(() {
            txColor = color;
          });
        });
  }
}
