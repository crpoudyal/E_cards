import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memesansar/widgets/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String text = "";
  double top = 10;
  double left = 10;
  Color bgcolor = Colors.orange;
  Color txColor = Colors.white;
  File? _image;
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
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
                            onPressed: () {},
                            icon: const Icon(Icons.text_fields)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
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
                              child: Text(
                                text,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: txColor),
                              ))
                        ],
                      ),
                      onVerticalDragUpdate: (DragUpdateDetails dd) {
                        setState(() {
                          top = dd.localPosition.dy;
                          left = dd.localPosition.dx;
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
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Share")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
