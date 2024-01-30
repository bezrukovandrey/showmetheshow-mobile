import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/show_info_screen.dart';
import '../providers/show.dart';
import '../providers/watchlist.dart';

class ShowItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final show = Provider.of<Show>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ShowInfoScreen.routeName,
                  arguments: show.id,
                );
              },
              child: Hero(
                tag: show.id,
                child: FadeInImage(
                  placeholder: AssetImage('assets/main-logo.png'),
                  image: NetworkImage(
                    show.img,
                  ),
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Consumer<WatchList>(
                  builder: (context, watchlist, _) => Icon(
                    watchlist.isInList(show.id)
                        ? Icons.star
                        : Icons.star_border,
                    color: Color.fromRGBO(250, 191, 71, 1),
                  ),
                ),
                onPressed: () {
                  final watchlist =
                      Provider.of<WatchList>(context, listen: false);
                  if (watchlist.isInList(show.id)) {
                    watchlist.removeItem(show.id);
                  } else {
                    watchlist.addItem(show.id, show.img, show.title);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
