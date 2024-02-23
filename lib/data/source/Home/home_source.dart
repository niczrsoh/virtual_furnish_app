import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class HomeDataSource {
    static final client = http.Client();
    static const urlLink = "https://jsonplaceholder.typicode.com/posts";
  static Future fetchHomeData() async {
    try{
    var response = await client
        .get(Uri.parse(urlLink));
        return response;
        }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future addHomeData(Map<String, dynamic> data) async {
    try{
    var response = await client
        .post(Uri.parse(urlLink), body: {
      'title': data['title'],
      'body': data['body'],
      'userId':
          '12', //cannot use userId as integer here because the side uses string for userId when adding data
    });
    return response;}
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
