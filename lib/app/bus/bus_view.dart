import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bus_favourites_view.dart';
import 'bus_nearby_view.dart';

final bottomBarIndexStateProvider = StateProvider<int>((ref) => 0);

class BusView extends HookWidget {
  Widget _getViewForIndex(int index) {
    switch (index) {
      case 0:
        return BusNearbyView();
      case 1:
        return BusFavouritesView();
      default:
        return BusNearbyView();
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarIndex = useProvider(bottomBarIndexStateProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Bus View'),
      ),
      body: _getViewForIndex(bottomBarIndex.state),
      bottomNavigationBar: ConvexAppBar(
        key: Key('BottomBar'),
        color: Theme.of(context).primaryColorDark,
        activeColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        top: -25.0,
        style: TabStyle.react,
        initialActiveIndex: bottomBarIndex.state,
        onTap: (int i) => bottomBarIndex.state = i,
        items: [
          TabItem(
            icon: Icons.location_searching,
            title: 'Nearby',
          ),
          TabItem(
            icon: Icons.favorite,
            title: 'Favorites',
          )
        ],
      ),
    );
  }
}
