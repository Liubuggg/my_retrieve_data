import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
//如果您向同一服务器发出多个请求，则可以通过aClient保持持久连接，该客户端的方法与顶级服务器的方法相似。完成后，请确保使用close方法进行清理：
void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final client = RetryClient(http.Client());
  try {
    final httpPackageInfo = await client.read(httpPackageUrl);
    print(httpPackageInfo);
  } finally {
    client.close();
  }
}
