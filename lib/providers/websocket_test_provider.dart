import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final webSocketProvider = StreamProvider.autoDispose((ref) {
  final channel = WebSocketChannel.connect(Uri.parse('ws://mobileapp.rocketbot.pro/api/ws'));
  try {
    ref.onDispose(() {
      print("disposing");
      channel.sink.close();
    });
    return channel.stream;
  } catch (e) {
    channel.sink.close();
    print(e);
    return const Stream.empty();
  }

});

