import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("meme sansar"),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
        ],
      ),
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
                            onPressed: () {}, icon: const Icon(Icons.image)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.add)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.amp_stories)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.format_color_fill)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.text_fields)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: const BoxDecoration(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
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
}
