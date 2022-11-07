import 'dart:io';

import 'package:Ecards/model/text_info.dart';
import 'package:Ecards/widgets/drawer_widget.dart';
import 'package:Ecards/widgets/edit_image.dart';
import 'package:Ecards/widgets/image_text.dart';
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

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

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
                    visibleData(),
                    const SizedBox(
                      height: 10,
                    ),
                    Screenshot(
                      controller: screenshotController,
                      child: Stack(
                        children: [
                          _image != null
                              ? InteractiveViewer(
                                  minScale: 0.1,
                                  child: Image.file(
                                    _image!,
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Container(
                                  height: containerHeight,
                                  width: double.infinity,
                                  color: bgcolor,
                                ),
                          for (int i = 0; i < texts.length; i++)
                            Positioned(
                              left: texts[i].left,
                              top: texts[i].top,
                              child: GestureDetector(
                                onDoubleTap: () {
                                  setState(() {
                                    currentIndex = i;
                                    removeText(context);
                                  });
                                },
                                onTap: () => setCurrentIndex(context, i),
                                child: Draggable(
                                  feedback: ImageText(textInfo: texts[i]),
                                  childWhenDragging: Container(),
                                  onDragEnd: (drag) {
                                    final renderBox =
                                        context.findRenderObject() as RenderBox;
                                    Offset off =
                                        renderBox.globalToLocal(drag.offset);
                                    setState(() {
                                      texts[i].top = off.dy - 200;
                                      texts[i].left = off.dx;
                                    });
                                  },
                                  child: ImageText(textInfo: texts[i]),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: textEditingController,
                      onChanged: (_) {
                        setState(() {
                          texts.add(
                            TextInfo(
                              text: textEditingController.text,
                              left: 20,
                              top: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              underline: TextDecoration.none,
                              linethrough: TextDecoration.none,
                              textAlign: TextAlign.left,
                            ),
                          );
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Type something...",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          textEditingController.clear();
                        },
                        child: const Text("Save")),
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
}
