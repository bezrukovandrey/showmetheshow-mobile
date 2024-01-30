import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './screens/watchlist_screen.dart';
import './screens/shows_screen.dart';
import './screens/show_info_screen.dart';
import './providers/show.dart';
import './providers/watchlist.dart';
import './screens/greetings_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        AndroidNotificationChannel(
          'watchlist_channel',
          'Watchlist Notifications',
          importance: Importance.max,
          playSound: true,
        ),
      );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Shows(),
        ),
        ChangeNotifierProvider.value(
          value: WatchList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'showmetheshow',
        home: GreetScreen(),
        routes: {
          ShowInfoScreen.routeName: (ctx) => ShowInfoScreen(),
          WatchListScreen.routeName: (ctx) => WatchListScreen(),
          ShowsScreen.routeName: (ctx) => ShowsScreen(
                flutterLocalNotificationsPlugin:
                    flutterLocalNotificationsPlugin,
              ),
        },
        theme: ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(255, 222, 194, 1)),
      ),
    );
  }
}
