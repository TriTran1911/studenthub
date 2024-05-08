import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  IO.Socket connectSocket() {
    IO.Socket socket = IO.io(
        'https://api.studenthub.dev',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    SharedPreferences.getInstance().then((prefs) {
      String token = prefs.getString('token')!;
      print("Token: $token");
      socket.io.options?['extraHeaders'] = {
        'Authorization': 'Bearer $token',
      };
      return socket;
    });

    return socket;
  }
}
