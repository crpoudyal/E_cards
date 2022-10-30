import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: const [
          ListTile(leading: Icon(Icons.person), title: Text('Profile')),
          ListTile(title: Text('About')),
          ListTile(title: Text('Profile')),
        ],
      ),
    ));
  }
}
