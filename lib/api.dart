import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wormhole/log.dart';
import 'package:wormhole/providers.dart';

const _apiUrl = "api.wormhole.club";
WebSocketChannel? channel;

Future<dynamic> apiPost(String path, Object? body) async {
  final res = await http.post(Uri.parse("https://$_apiUrl$path"), body: body);
  final json = jsonDecode(res.body);

  if (res.statusCode != 202) {
    return Future.error(ApiException(path, json["error"]));
  }

  return json;
}

Future<void> connectChannel() async {
  if (channel != null) return;

  try {
    log.info("Connecting to web socket");
    channel = WebSocketChannel.connect(Uri.parse("ws://$_apiUrl/connect?token=${container.read(tokenProvider)}"));

    await channel!.ready;
    log.info("Connected");
  }
  on WebSocketException catch (e) {
    log.error("Failed to open a web socket connection: $e");
    return;
  }

  channel!.stream.listen(
    (event) {
      final data = jsonDecode(event);
      final message = "${data['sender']['username']}: ${data['content']}";

      log.debug(message);
      
      container.read(messagesProvider.notifier).add(message);
    },
    onError: (error) {
      log.error("Web socket error: $error");
      channel!.sink.close(status.protocolError);
    },
    onDone: () {
      log.info("Closing web socket connection");
    },
  );
}

void sendMessage(String message) {
  channel!.sink.add("{\"content\": \"$message\"}");
}

class ApiException implements Exception {
  String path;
  String error;

  ApiException(this.path, this.error);

  @override
  String toString() {
    return "API Exception on $path - $error";
  }
}
