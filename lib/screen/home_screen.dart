import 'dart:io';
import 'dart:math';

import 'package:Ecards/widgets/drawer_widget.dart';
import 'package:Ecards/widgets/edit_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends EditImage {
  File? _image;
  bool _isVisible = false;

  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-cards"),
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
      drawer: const DrawerWidget(),
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
                              visibleTextEditControl();
                            },
                            icon: const Icon(Icons.text_fields)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: _isVisible,
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("size"),
                                  Slider(
                                      value: value,
                                      onChanged: (val) {
                                        setState(() {
                                          value = val;
                                        });
                                      })
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("size"),
                                  Slider(
                                      value: value,
                                      onChanged: (val) {
                                        setState(() {
                                          value = val;
                                        });
                                      })
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Screenshot(
                        controller: screenshotController,
                        child: Stack(
                          children: [
                            _image != null
                                ? InteractiveViewer(
                                    minScale: 0.1,
                                    child: Image.file(_image!,
                                        height: 300,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                  )
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
                      controller: textEditingController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              text = textEditingController.text;
                              textEditingController.text = "";
                            });
                          },
                          child: const Text("Save"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              textEditingController.text = "";
                            });
                          },
                          child: const Text("Clear"),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  void visibleTextEditControl() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
}
