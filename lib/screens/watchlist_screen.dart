import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watchlist.dart' show WatchList;
import '../widgets/list_item.dart';

class WatchListScreen extends StatelessWidget {
  static const routeName = '/watchlist';

  @override
  Widget build(BuildContext context) {
    final watchlist = Provider.of<WatchList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your watchlist',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Bitter',
              color: Color.fromRGBO(255, 222, 194, 1),
            )),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(142, 65, 133, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: watchlist.items.length,
              itemBuilder: (ctx, i) => WatchListItem(
                watchlist.items.values.toList()[i].id,
                watchlist.items.keys.toList()[i],
                watchlist.items.values.toList()[i].title,
                watchlist.items.values.toList()[i].img,
              ),
            ),
          )
        ],
      ),
    );
  }
}
