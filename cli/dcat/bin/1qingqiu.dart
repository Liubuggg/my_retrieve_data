import 'package:http/http.dart' as http;
//如果您只需要快速获取请求资源的字符串表示，则可以使用包http中的顶级读取函数，该函数会返回Future＜string＞，或者在请求未成功时抛出ClientException。
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
