import 'package:http/http.dart' as http;

class RequestHelper {
  // final _header = {"key": "706e2b2818538987ab9cb703ada4f9ca"};
  String _location = "";

  RequestHelper({required String location}) {
    _location = location;
  }

  Future<http.Response> makeRequest() async {
    return await http.get(
      Uri.parse(
        "https://muslimsalat.com/$_location.json?key=706e2b2818538987ab9cb703ada4f9ca",
      ),
      // headers: _header,
    );
  }
}
