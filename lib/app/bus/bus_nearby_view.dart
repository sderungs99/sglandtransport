import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../../common_widgets/staggered_animation.dart';
import '../../services/api.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import 'bus_stop.dart';
import 'models/bus_stop_model.dart';

/// Provides a stream of user location information
final locationStreamProvider = StreamProvider.autoDispose<LocationData>((ref) {
  final locationService = ref.read(locationServiceProvider);

  return locationService.getLocationStream();
});

/// Provides a stream of nearby bus stops, based on
/// user location
final nearbyBusStopsProvider =
    StreamProvider.autoDispose<List<BusStopModel>>((ref) async* {
  final databaseService = ref.read(databaseServiceProvider);
  final api = ref.read(apiProvider);

  var locationStream = ref.watch(locationStreamProvider.stream);

  // fetch all bus stops from DB
  var allBusStops = await databaseService.getBusStops();

  // if not populated, fetch from API and write result into DB
  if (allBusStops.isEmpty) {
    allBusStops = await api.fetchBusStopList();
    await databaseService.insertBusStops(allBusStops);
    await databaseService.insertBusStopsTableCreationDate(
        millisecondsSinceEpoch: DateTime.now().millisecondsSinceEpoch);
  }

  await for (var locationData in locationStream) {
    final nearbyBusStops = <BusStopModel>[];
    final distance = Distance();

    // filter DB result by location
    for (var busStop in allBusStops) {
      final distanceInMeters = distance(
        LatLng(locationData.latitude, locationData.longitude),
        LatLng(busStop.latitude, busStop.longitude),
      );
      if (distanceInMeters <= 500) {
        final newBusStop =
            busStop.copyWith(distanceInMeters: distanceInMeters.round());

        nearbyBusStops.add(newBusStop);
      }
    }
    // sort result by distance
    nearbyBusStops.sort(
        (var a, var b) => a.distanceInMeters.compareTo(b.distanceInMeters));

    yield nearbyBusStops;
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
          return Center(
            child: JumpingText('Looking for nearby bus stops...'),
          );
        }
        return AnimationLimiter(
          child: ListView.builder(
            itemCount: busStopModelList.length,
            itemBuilder: (context, index) {
              return StaggeredAnimation(
                index: index,
                child: BusStop(busStopModel: busStopModelList[index]),
              );
            },
          ),
        );
      },
      loading: () =>
          Center(child: JumpingText('Looking for nearby bus stops...')),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
