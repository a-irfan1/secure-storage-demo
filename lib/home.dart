import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final nameController = TextEditingController();
  final messageController = TextEditingController();
  final searchController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Storage Demo"),
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: 'Enter a name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: messageController,
                      decoration:
                          const InputDecoration(hintText: 'Enter a message'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.3, 50),
                          ),
                          onPressed: () async {
                            await storage.write(
                                key: nameController.text,
                                value: messageController.text);
                            nameController.clear();
                            messageController.clear();
                          },
                          child: const Text("Submit"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.3, 50),
                          ),
                          onPressed: () {
                            nameController.clear();
                            messageController.clear();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: searchController,
                      decoration:
                          const InputDecoration(hintText: 'Enter a name'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.7, 50),
                      ),
                      onPressed: () async {
                        final result = await storage.containsKey(
                            key: searchController.text);
                        String? value;
                        result
                            ? value =
                                (await storage.read(key: searchController.text))
                            : value = "";
                        if (context.mounted) {
                          result
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          "${searchController.text} wrote: $value"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(
                                          "${searchController.text} not found in storage!"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                        }
                      },
                      child: const Text("Search"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
