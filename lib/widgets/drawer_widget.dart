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
          Center(
            child: Text(
              "Select E-cards",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          ListTile(title: Text('Holi - होली')),
          ListTile(title: Text('Chatt Puja - छठ पूजा')),
          ListTile(title: Text('Tihar - तिहार')),
          ListTile(title: Text('Dashain - दशैं')),
          ListTile(title: Text('Shamadhan Diwash - सम्बिधान दिवस')),
          ListTile(title: Text('Indra Jatra - इन्द्र जात्रा')),
          ListTile(title: Text('Gai Jatra - गाई जात्रा')),
          ListTile(title: Text('Ghoda Jatra - घोडे जात्रा')),
          ListTile(title: Text('Teej - तीज')),
        ],
      ),
    ));
  }
}
