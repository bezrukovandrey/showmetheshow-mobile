import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Show with ChangeNotifier {
  final String id;

  final String title;
  final String imdbLink;
  final String year;
  final String img;
  final List<String> category;
  final String description;

  Show({
    required this.id,
    required this.title,
    required this.imdbLink,
    required this.year,
    required this.img,
    required this.category,
    required this.description,
  });

  factory Show.fromJson(dynamic json) {
    return Show(
      id: json['imdbid'] as String,
      title: json['title'] as String,
      imdbLink: json['imdb_link'] as String,
      year: json['year'] as String,
      img: json['image'] as String,
      category: (json['genre'] as List<dynamic>).cast<String>(),
      description: json['description'] as String,
    );
  }
}

class Shows with ChangeNotifier {
  List<Show> _items = [];
  bool _isLoading = true;

  List<Show> get items {
    return [..._items];
  }

  bool get isLoading {
    return _isLoading;
  }

  Show findById(String id) {
    return _items.firstWhere((sh) => sh.id == id);
  }

  Future<List<Show>> getShows() async {
    try {
      var uri = Uri.https(
        'imdb-top-100-movies.p.rapidapi.com',
        '/series',
      );

      final response = await http.get(uri, headers: {
        'X-RapidAPI-Key': '5c2bc457ffmshf87552187109e1bp103a92jsnae15745a6ee7',
        'X-RapidAPI-Host': 'imdb-top-100-movies.p.rapidapi.com'
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _items = data.map((json) => Show.fromJson(json)).toList();
        _isLoading = false;
        notifyListeners();
        return _items;
      } else {
        print('API request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load shows');
      }
    } catch (error) {
      print("Error loading shows: $error");
      throw error;
    }
  }
}
