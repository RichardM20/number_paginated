import 'dart:convert';

import 'package:example/user_model.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPosts({int limit = 100}) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=$limit'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => Post.fromJson(e)).toList();
  } else {
    throw Exception('Error al cargar posts: Código ${response.statusCode}');
  }
}
