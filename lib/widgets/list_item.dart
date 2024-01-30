import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watchlist.dart';
import '../screens/show_info_screen.dart';

class WatchListItem extends StatelessWidget {
  final String id;
  final String showId;
  final String img;
  final String title;

  WatchListItem(
    this.id,
    this.showId,
    this.img,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.grey,
        child: Icon(
          Icons.delete,
          color: Colors.grey[600],
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<WatchList>(context, listen: false).removeItem(showId);
      },
      child: Card(
        color: Color.fromRGBO(250, 191, 71, 1),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(img),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bitter',
                      color: Colors.brown[800]),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                color: Colors.brown[800],
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ShowInfoScreen.routeName,
                    arguments: showId,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
