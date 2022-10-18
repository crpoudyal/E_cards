import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memesansar/widgets/drawer_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  String text = "";
  double top = 10;
  double left = 10;
  double _value = 20;
  double finalAngle = 0.0;
  Color bgcolor = Colors.orange;
  Color txColor = Colors.white;
  File? _image;

  // Handling Permission for Storage

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    final info = statuses[Permission.storage].toString();
    print(info);
  }

  // Getting gallery Image with ImagePicker pkg
  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final tempImage = File(image.path);

    setState(() {
      _image = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("meme sansar"),
        actions: [
          IconButton(
              onPressed: () {
                screenshotController.capture().then((capturedImage) async {
                  showCapturedImage(context, capturedImage!);
                }).catchError((onError) {
                  print(onError);
                });
              },
              icon: const Icon(Icons.download)),
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () {
                              getImage();
                            },
                            icon: const Icon(Icons.image)),
                        IconButton(
                            onPressed: () {
                              pickTxColor(context);
                            },
                            icon: const Icon(Icons.text_format)),
                        IconButton(
                            onPressed: () {
                              pickBgColor(context);
                            },
                            icon: const Icon(Icons.format_color_fill)),
                        IconButton(
                            onPressed: () {
                              txEdit(context);
                            },
                            icon: const Icon(Icons.text_fields)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Screenshot(
                        controller: screenshotController,
                        child: Stack(
                          children: [
                            _image != null
                                ? Image.file(_image!,
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.cover)
                                : Container(
                                    height: 300,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: bgcolor,
                                    )),
                            Positioned(
                              top: top,
                              left: left,
                              child: Transform.rotate(
                                angle: finalAngle,
                                origin: const Offset(0, 0),
                                child: Text(
                                  text,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: txColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // for rotating text widget
                      onPanUpdate: (details) {
                        setState(() {
                          finalAngle += details.delta.distance * pi / 180;
                        });
                      },
                      // for moving text widget
                      onVerticalDragUpdate: (DragUpdateDetails dd) {
                        setState(() {
                          top = dd.localPosition.dy - 50;
                          left = dd.localPosition.dx - 50;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (data) {
                        setState(() {
                          text = data;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Type something...",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                  final imagepick = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (imagepick == null) {
                    return;
                  }
                  await Share.shareFiles([imagepick.path]);
                },
                child: const Text("Share")),
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
    final name = "memesansar_$time";
    await _requestPermission();
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  void pickBgColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick color for Background"),
            content: Column(
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
  void txEdit(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Style Text"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTxStylePicker(),
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

  Widget buildTxStylePicker() {
    return Column(
      children: [
        Row(
          children: [
            const Text("Size"),
            Slider(
              min: 0.0,
              max: 100.0,
              value: _value,
              onChanged: (val) {
                setState(() {
                  val = _value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
