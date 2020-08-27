import 'dart:convert';
import 'dart:io';
import 'dart:async';


Future main () async {
  print("Started");
  await HttpServer.bind("192.168.1.3", 25565)
  ..listen((HttpRequest request) {
    if (request.method == "POST") {
      print(request.toString());
    }

    else {
      request.response.write("Recived an unsupported request method: ${request.method}");
    }
    request.response.close();
  });
}