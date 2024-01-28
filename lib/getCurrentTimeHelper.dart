import 'package:http/http.dart' as http;

Future<http.Response> getCurrentTime(
    {required String latitude, required String longitude}) async {
  return await http.get(
    Uri.parse(
        "https://timeapi.io/api/Time/current/coordinate?latitude=$latitude&longitude=$longitude"),
    // headers: {"latitude": latitude, "longitude": longitude},
  );
}
