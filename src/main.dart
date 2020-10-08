import 'dart:io';
import 'dart:async';
import 'dart:convert';


Future main () async {
  int red = 0;
  int green = 0;
  int blue = 0;
  bool power = false;

  print("Started");
  await HttpServer.bind("192.168.1.3", 25565)
  ..listen((HttpRequest request) async {
    
    if (request.requestedUri.path == "/api") { //if recived a post or get request on the /api route then go ahead and continue.

      if (request.method == "POST") { // post method.
        Map<dynamic, dynamic> data = request.uri.queryParameters;
        if (data["r"] != null && data["g"] != null && data["b"] != null) { //if colors are specified then go ahead and run the script.
          red = int.parse(data["r"]); green = int.parse(data["g"]); blue = int.parse(data["b"]); //sets the red, green and blue varibles to the queryParameters.
          //Process.start("./lightscripts/lightswitch.py", ["${data["power"]}", "${data["r"]}", "${data["g"]}", "${data["b"]}"]);
        }
        else {
          request.response.write("Recived bad parameters: ${data}");
        }
      }
      else if (request.method == "GET") { //get method.
        print("Get request recived.");
        Map<dynamic, dynamic> body = { //creates a body for the get response with all the right key:pair values.
          "power" : power, 
          "r" : red,
          "g" : green,
          "b" : blue
        };
        request.response.write(json.encode(body));
      }
      else {
        request.response.statusCode = 400;
        request.response.write("Recived an unsupported request method: ${request.method}"); //if server gets an unsupported request type then send back a status code of 400(Bad request).
      }
    }
    
    request.response.close();
  });
}