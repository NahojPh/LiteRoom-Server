import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future main() async {

  File file = File("lightData.json");
  Map<dynamic, dynamic> fileData;
  try {
    fileData = json.decode(file.readAsStringSync());
  } 
  catch (e) {
    print("fileData is not happy with not exisiting: \n $e");
  }
  

  if (fileData["color"] == null || fileData["power"] == null) {
    file.createSync();
    file.writeAsString('{"power" : false, "color" : 1}');
    fileData = json.decode(file.readAsStringSync());
  }

  int color = fileData["color"];
  bool power = fileData["power"];

  print("Started");
  await HttpServer.bind("192.168.1.3", 25565)
    ..listen((HttpRequest request) async {
      print("listeing");
      if (request.requestedUri.path == "/api") { //if recived a post or get request on the /api route then go ahead and continue.
        
        print("inside /api");
        if (request.method == "POST") { // post method.
        print("post request recv");
          Map<dynamic, dynamic> data = request.uri.queryParameters;
          if (data["color"] != null) { //if colors are specified then go ahead and run the script.
           
            color = int.parse(data["color"]); //sets the color varible to the queryParameters.
            file.writeAsString(fileData.toString()); //When the data of a post reqeust is recived. Write it to the save file.
            print("colors gotten: $color");
            //Process.start("./lightscripts/lightswitch.py", ["${data["power"]}", "${data["color"]}]);
          }
          else {
            request.response.write("Recived bad parameters: ${data}");
          }
        }
        else if (request.method == "GET") { //get method.
         
          print("Get request recived.");
          Map<dynamic, dynamic> body = { //creates the body for the get response with all the right key:pair values.
            "power": power,
            "color": color,
          };
          request.response.write(json.encode(body)); //json encodest he body and sends it as a response.
        } 
        else {
          request.response.statusCode = 400;
          request.response.write("Recived an unsupported request method: ${request.method}"); //if server gets an unsupported request type then send back a status code of 400(Bad request).
        }
      }
      request.response.close();
    });
}
