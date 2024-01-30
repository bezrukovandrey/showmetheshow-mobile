import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WatchListItem {
  final String id;
  final String title;
  final String img;

  WatchListItem({
    required this.id,
    required this.title,
    required this.img,
  });
}

class WatchList with ChangeNotifier {
  Map<String, WatchListItem> _items = {};

  Map<String, WatchListItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> get() async {
    final url = Uri.https(
      'showmetheshow-44d2d-default-rtdb.firebaseio.com',
      'watching-list.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _items = responseData.map((key, value) {
          return MapEntry(
            key,
            WatchListItem(
              id: key,
              title: value['title'],
              img: value['img'],
            ),
          );
        });
        notifyListeners();
      } else {
        print('HTTP Request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP Request: $error');
    }
  }

  Future<void> addItem(
    String showId,
    String title,
    String img,
  ) async {
    final url = Uri.https(
      'showmetheshow-44d2d-default-rtdb.firebaseio.com',
      'watching-list.json',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'img': img,
        }),
      );

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        // final generatedId = responseData['name'];
        _items.putIfAbsent(
          showId,
          () => WatchListItem(
            id: DateTime.now().toString(),
            title: title,
            img: img,
          ),
        );
        notifyListeners();
      } else {
        print('HTTP Request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP Request: $error');
    }
  }

  Future<void> removeItem(String showId) async {
    final url = Uri.https(
      'showmetheshow-44d2d-default-rtdb.firebaseio.com',
      'watching-list/$showId.json',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _items.remove(showId);

        notifyListeners();
      } else {
        print('HTTP Request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP Request: $error');
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  bool isInList(String showId) {
    return _items.containsKey(showId);
  }
}
