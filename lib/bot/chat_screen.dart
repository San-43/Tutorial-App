import 'dart:convert';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<Message> msgs = [];

  bool isTyping = false;

  void sendMsg() async {
    String text = controller.text;
    controller.clear();

    try {
      if (text.isNotEmpty) {
        setState(() {
          msgs.insert(0, Message(true, text));
          isTyping = true;
        });

        scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );

        var response = await http.post(
          Uri.parse("http://192.168.1.17:1234/v1/chat/completions"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "model": "phi-3.1-mini-128k-instruct",
            "messages": [
              {
                "role": "system",
                "content":
                '''Your name is Flutter Bot. You are an expert assistant specialized in Flutter, the UI toolkit from Google for building mobile, web, and desktop applications from a single codebase.
                    You were created by the team Dos Tequilas y Un Mojito.
                    Do not mention that you are a language model or AI. You are simply Flutter Bot, an expert in Flutter.
                    You only speak in Spanish.
                    You are designed to act as a quick-answer bot — providing brief, direct answers to simple Flutter-related questions such as:
                    What is a widget?
                    How do I write a widget?
                    How do I install Flutter?
                    You must only answer questions related to Flutter, including Dart, widgets, UI design, navigation, package integration, and best development practices using Flutter.
                    If the user asks anything unrelated to Flutter — such as artificial intelligence, mathematics, history, medicine, politics, or other programming languages or frameworks — politely respond that you can only talk about Flutter.
                    If a question requires more information than a quick answer, provide a short response in Spanish and include only one official or reliable link for further reference (e.g., from flutter.dev or pub.dev).
                    Your goal is to be clear, concise, and helpful for developers working on Flutter projects.
                ''',
              },
              {"role": "user", "content": text},
            ],
            "temperature": 0,
            "max_tokens": 350,
          }),
        );

        print(response.body);

        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          setState(() {
            isTyping = false;
            msgs.insert(
              0,
              Message(
                false,
                json["choices"][0]["message"]["content"].toString().trimLeft(),
              ),
            );
          });

          scrollController.animateTo(
            0.0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeOut,
          );
        } else {
          throw Exception("Failed to get response");
        }
      }
    } on Exception catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocurrió un error, intenta nuevamente.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Bot")),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: msgs.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child:
                    isTyping && index == 0
                        ? Column(
                      children: [
                        BubbleNormal(
                          text: msgs[0].msg,
                          isSender: true,
                          color: Colors.blue.shade100,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16, top: 4),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Escribiendo..."),
                          ),
                        ),
                      ],
                    )
                        : BubbleNormal(
                      text: msgs[index].msg,
                      isSender: msgs[index].isSender,
                      color:
                      msgs[index].isSender
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: controller,
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: (value) {
                            sendMsg();
                          },
                          textInputAction: TextInputAction.send,
                          showCursor: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter text",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    sendMsg();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}