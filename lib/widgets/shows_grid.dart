import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/show.dart';

import './show_item.dart';

class ShowsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showsData = Provider.of<Shows>(context);
    final shows = showsData.items;

    return showsData.isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: shows.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: shows[i],
              child: ShowItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
