import 'package:http/http.dart' as http;

Future<http.Response> getCurrentTime(
    {required String latitude, required String longitude}) async {
  return await http.get(
      Uri.parse("https://timeapi.io/api/Time/current/coordinate"),
      headers: {"latitude": latitude, "longitude": longitude});
}
