import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wormhole/api.dart';
import 'package:wormhole/providers.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends ConsumerState<ChatPage> {
  final message = TextEditingController();
  final focusNode = FocusNode();

  void send() {
    if (message.text.isEmpty) return;

    sendMessage(message.text);

    message.clear();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    message.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectChannel();

    final messages = ref.watch(messagesProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => Text(messages[index]),
              )
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextField(
                      controller: message,
                      onSubmitted: (_) => send(),
                      autofocus: true,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: "Message",
                        border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: send,
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}