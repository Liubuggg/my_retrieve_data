import 'package:http/http.dart' as http;

void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  try {
    final httpPackageResponse = await http.get(httpPackageUrl);
    if (httpPackageResponse.statusCode != 200) {
      print(
          'Failed to retrieve the http package! Status code: ${httpPackageResponse.statusCode}');
      return;
    }
    print(httpPackageResponse.body);
  } catch (e) {
    print('Error fetching the http package: $e');
  }
}
