import 'dart:io';
import 'dart:async';


Future main () async {
  print("Started");
  await HttpServer.bind("192.168.1.3", 25565)
  ..listen((HttpRequest request) async {

    if (request.requestedUri.path == "/api") { //if recived a post or get request on the /api route then go ahead.

      if (request.method == "POST") { // post method. Post handeler starts here.
        Map<dynamic, dynamic> data = request.uri.queryParameters;
        if (data["r"] != null && data["g"] != null && data["b"] != null) { //if colors are specified then go ahead and run the script.
          print(data);
          //Process.start("./lightscripts/lightswitch.py", ["${data["power"]}", "${data["r"]}", "${data["g"]}", "${data["b"]}"]);
        }
        else {
          request.response.write("Recived bad parameters: ${data}");
        }
      }
      else if (request.method == "GET") { //get method
        request.response.write("${DateTime.now()}");
      }
      else {
        request.response.statusCode = 400;
        request.response.write("Recived an unsupported request method: ${request.method}"); //if server gets an unsupported request type then send back a 
      }
    }
    
    request.response.close();
  });
}