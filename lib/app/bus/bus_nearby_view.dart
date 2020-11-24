import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../common_widgets/error_view.dart';
import '../../common_widgets/staggered_animation.dart';
import '../../services/location_service.dart';
import '../failure.dart';
import 'bus_nearby_viewmodel.dart';
import 'bus_stop_card.dart';
import 'models/bus_stop_model.dart';

/// Provides a stream of user location information
final locationStreamProvider = StreamProvider.autoDispose<LocationData>((ref) {
  final locationService = ref.read(locationServiceProvider);

  print('---- in locationStreamProvider ----');

  return locationService.getLocationStream();
});

/// Provides a stream of nearby bus stops, based on
/// user location
final nearbyBusStopsProvider =
    StreamProvider.autoDispose<List<BusStopModel>>((ref) async* {
  final vm = ref.read(busNearbyViewModelProvider);

  var allBusStops = <BusStopModel>[];

  allBusStops = await vm.getBusStops();

  // filter and yield a value whenever a new location is provided via the
  // location stream
  var locationStream = ref.watch(locationStreamProvider.stream);
  await for (var locationData in locationStream) {
    yield vm.filterBusStopsByLocation(
        allBusStops, locationData.latitude, locationData.longitude);
  }
});

/// The main view that shows nearby bus stops
class BusNearbyView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var locationData = useProvider(nearbyBusStopsProvider);

    return locationData.when(
      data: (busStopModelList) {
        if (busStopModelList.isEmpty) {
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  height: 20,
                ),
                JumpingText('Looking for nearby bus stops...'),
              ],
            ),
          );
        }
        return AnimationLimiter(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: busStopModelList.length,
              itemBuilder: (context, index) {
                return StaggeredAnimation(
                  index: index,
                  child: BusStopCard(
                    busStopModel: busStopModelList[index],
                    key: ValueKey<String>('busStopCard-$index'),
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () =>
          Center(child: JumpingText('Looking for nearby bus stops...')),
      error: (err, stack) {
        if (err is Failure) {
          return ErrorView(message: err.message);
        }
        return ErrorView();
      },
    );
  }
}
