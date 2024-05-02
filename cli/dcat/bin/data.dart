import 'dart:convert';

import 'package:http/http.dart' as http;

// 定义一个类来表示包的信息
class PackageInfo {
  final String name;
  final String latestVersion;
  final String description;
  final String publisher;
  final Uri? repository;

  PackageInfo({
    required this.name,
    required this.latestVersion,
    required this.description,
    required this.publisher,
    this.repository,
  });

  // 从JSON映射创建PackageInfo对象的工厂构造函数
  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    final repository = json['repository'] as String?;

    return PackageInfo(
      name: json['name'] as String,
      latestVersion: json['latestVersion'] as String,
      description: json['description'] as String,
      publisher: json['publisher'] as String,
      repository: repository != null ? Uri.tryParse(repository) : null,
    );
  }
}

// 定义一个异步函数来获取包信息
Future<PackageInfo> getPackage(String packageName) async {
  final packageUrl = Uri.https('dart.dev', '/f/packages/$packageName.json');
  try {
    final packageResponse = await http.get(packageUrl);

    // 如果请求不成功，抛出一个异常
    if (packageResponse.statusCode != 200) {
      throw PackageRetrievalException(
        packageName: packageName,
        statusCode: packageResponse.statusCode,
      );
    }

    final packageJson =
        json.decode(packageResponse.body) as Map<String, dynamic>;

    return PackageInfo.fromJson(packageJson);
  } catch (e) {
    // 重新抛出异常，作为PackageRetrievalException
    throw PackageRetrievalException(
      packageName: packageName,
      statusCode: null,
    );
  }
}

// 定义一个异常类来处理包信息获取失败的情况
class PackageRetrievalException implements Exception {
  final String packageName;
  final int? statusCode;

  PackageRetrievalException({required this.packageName, this.statusCode});

  @override
  String toString() {
    return 'Failed to retrieve package "$packageName":${statusCode != null ? 'Status code: $statusCode' : 'Unknown error'}';
  }
}

// 程序的入口点
void main() async {
  try {
    final packageName = 'http';
    final packageInfo = await getPackage(packageName);
    print('Package Name: ${packageInfo.name}');
    print('Latest Version: ${packageInfo.latestVersion}');
    print('Description: ${packageInfo.description}');
    print('Publisher: ${packageInfo.publisher}');
    if (packageInfo.repository != null) {
      print('Repository: ${packageInfo.repository}');
    }
  } catch (e) {
    print(e);
  }
}
