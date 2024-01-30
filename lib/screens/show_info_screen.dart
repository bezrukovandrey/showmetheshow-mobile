import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/show.dart';
import '../providers/watchlist.dart';

class ShowInfoScreen extends StatelessWidget {
  static const routeName = '/show-info';

  @override
  Widget build(BuildContext context) {
    final showId = ModalRoute.of(context)?.settings.arguments as String?;
    final loadedShow = Provider.of<Shows>(
      context,
      listen: false,
    ).findById(showId!);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedShow.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Bitter',
              color: Color.fromRGBO(255, 222, 194, 1),
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Consumer<WatchList>(
              builder: (context, watchlist, _) => Icon(
                watchlist.isInList(loadedShow.id)
                    ? Icons.star
                    : Icons.star_border,
                color: Color.fromRGBO(255, 222, 194, 1),
              ),
            ),
            onPressed: () {
              final watchlist = Provider.of<WatchList>(context, listen: false);
              if (watchlist.isInList(loadedShow.id)) {
                watchlist.removeItem(loadedShow.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from watchlist!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                watchlist.addItem(
                    loadedShow.id, loadedShow.img, loadedShow.title);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to watchlist!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
        backgroundColor: Color.fromRGBO(142, 65, 133, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 300,
                width: double.infinity,
                child: Hero(
                  tag: loadedShow.id,
                  child: Image.network(
                    loadedShow.img,
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(height: 10),
            _buildDetail('Year:', loadedShow.year.toString()),
            _buildDetail('IMDb:', loadedShow.imdbLink),
            _buildDetail('Genre:', loadedShow.category.join(', ')),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedShow.description,
                softWrap: true,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Ubuntu',
                  color: Colors.brown[800],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Ubuntu',
          color: Colors.brown[800],
        ),
      ),
    );
  }
}
