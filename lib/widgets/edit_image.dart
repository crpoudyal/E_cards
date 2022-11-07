import 'dart:io';
import 'dart:typed_data';

import 'package:Ecards/model/text_info.dart';
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

  double containerHeight = 300;
  Color bgcolor = Colors.orange;
  Color txColor = Colors.white;
  bool _isVisible = false;

  List<TextInfo> texts = [];
  int currentIndex = 0;

  // Handling Permission for Storage

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    statuses[Permission.storage].toString();
  }

  void visibleTextEditControl() {
    setState(() {
      _isVisible = !_isVisible;
    });
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
            Image.memory(capturedImage),
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
    final name = "Ecards_$time";
    await requestPermission();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "SELECT",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        texts[currentIndex].color = txColor;
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "SELECT",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
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
            texts[currentIndex].color = color;
          });
        });
  }

  Widget visibleData() {
    return Visibility(
      visible: _isVisible,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          boldText();
                        },
                        icon: const Icon(Icons.format_bold)),
                    IconButton(
                        onPressed: () {
                          italicText();
                        },
                        icon: const Icon(Icons.format_italic)),
                    IconButton(
                        onPressed: () {
                          underlineText();
                        },
                        icon: const Icon(Icons.format_underline)),
                    IconButton(
                        onPressed: () {
                          linethroughText();
                        },
                        icon: const Icon(Icons.format_strikethrough)),
                    IconButton(
                        onPressed: () {
                          leftAlign();
                        },
                        icon: const Icon(Icons.format_align_left)),
                    IconButton(
                        onPressed: () {
                          centerAlign();
                        },
                        icon: const Icon(Icons.format_align_center)),
                    IconButton(
                        onPressed: () {
                          rightAlign();
                        },
                        icon: const Icon(Icons.format_align_right)),
                    IconButton(
                        onPressed: () {
                          increaseFontSize();
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {
                          decreaseFontSize();
                        },
                        icon: const Icon(Icons.remove)),
                    IconButton(
                        onPressed: () {
                          addLinesToText();
                        },
                        icon: const Icon(Icons.space_bar)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
      textEditingController.text = texts[index].text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected for styling',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  underlineText() {
    setState(() {
      if (texts[currentIndex].underline == TextDecoration.underline) {
        texts[currentIndex].underline = TextDecoration.none;
      } else {
        texts[currentIndex].underline = TextDecoration.underline;
      }
    });
  }

  linethroughText() {
    setState(() {
      if (texts[currentIndex].underline == TextDecoration.lineThrough) {
        texts[currentIndex].underline = TextDecoration.none;
      } else {
        texts[currentIndex].underline = TextDecoration.lineThrough;
      }
    });
  }

  leftAlign() {
    setState(() {
      texts[currentIndex].textAlign == TextAlign.left;
    });
  }

  rightAlign() {
    setState(() {
      texts[currentIndex].textAlign == TextAlign.right;
    });
  }

  centerAlign() {
    setState(() {
      texts[currentIndex].textAlign == TextAlign.center;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }
}
