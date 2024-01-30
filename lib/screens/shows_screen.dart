import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../widgets/shows_grid.dart';
import '../widgets/my_badge.dart';

import '../providers/watchlist.dart';
import '../providers/show.dart';
import './watchlist_screen.dart';

class ShowsScreen extends StatefulWidget {
  static const routeName = '/shows';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ShowsScreen({required this.flutterLocalNotificationsPlugin});

  @override
  _ShowsScreenState createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  AndroidNotificationDetails? androidPlatformChannelSpecifics;
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'watchlist_channel',
      'Watchlist Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await widget.flutterLocalNotificationsPlugin.show(
      0,
      'Attention!',
      'There are 5 or more tv shows in your wath list. Keep adding :)',
      platformChannelSpecifics,
      payload: 'itemCount >= 5',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'showmetheshow',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Bitter',
            color: Color.fromRGBO(255, 222, 194, 1),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(142, 65, 133, 1),
        actions: <Widget>[
          Consumer<WatchList>(
            builder: (_, watchlist, ch) => MyBadge(
              child: ch!,
              value: watchlist.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.star,
                color: Color.fromRGBO(255, 222, 194, 1),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(WatchListScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Show>>(
        future: Provider.of<Shows>(context, listen: false).getShows(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading shows: ${snapshot.error}'));
          } else {
            final watchlist = Provider.of<WatchList>(context, listen: false);

            if (watchlist.itemCount >= 5) {
              _showNotification();
            }
            return ShowsGrid();
          }
        },
      ),
    );
  }
}
