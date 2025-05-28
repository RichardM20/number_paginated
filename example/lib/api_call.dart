import 'dart:convert';
import 'dart:io';

import 'package:example/user_model.dart';

Future<List<Post>> fetchPosts({int limit = 100}) async {
  final client = HttpClient();
  try {
    final request = await client.getUrl(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=$limit'),
    );
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> data = jsonDecode(responseBody);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar posts: Código ${response.statusCode}');
    }
  } finally {
    client.close();
  }
}
