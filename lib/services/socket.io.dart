import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:twitter_clone/services/NetworkHandler.dart';

class SocketHandler {
  var network = NetworkHandler();

  static IO.Socket socket;
  SocketHandler() {
    socket = IO.io(
        network.baseurl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .build());
    socket.connect();

    socket.onConnect((_) async {});

    socket.on('message', (data) => print('asdfasfd' + data.toString()));

    socket.on('test', (data) => print('server id' + data.toString()));
  }
}
