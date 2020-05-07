import 'package:flutter_test/flutter_test.dart';
import 'package:lta_datamall_flutter/models/bus_stops/bus_stop_model.dart';
import 'package:lta_datamall_flutter/services/bus/favorite_bus_stops_service_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const favoriteBusStopsKey = 'favoriteBusStopModels';
  final busStopModelList = [
    BusStopModel(
      '01013',
      'roadName1',
      'description1',
      1.1,
      1.2,
    ),
    BusStopModel(
      '02049',
      'roadName2',
      'description3',
      1.3,
      1.4,
    ),
    BusStopModel(
      '01019',
      'roadName3',
      'description3',
      1.5,
      1.6,
    )
  ];
  group('Shared Preferences', () {
    test('It returns favorite bus stops', () async {
      final busStops = [
        busStopModelList[0].busStopCode,
        busStopModelList[1].busStopCode,
      ];

      SharedPreferences.setMockInitialValues(
          <String, dynamic>{favoriteBusStopsKey: busStops});

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);

      await favoritesService.fetchFavoriteBusStops();

      expect(favoritesService.favoriteBusStops.length, busStops.length);
    });

    test('It tells if a given bus stop is already stored as a Favorite',
        () async {
      final busStops = [
        busStopModelList[0].busStopCode,
        busStopModelList[1].busStopCode,
      ];

      SharedPreferences.setMockInitialValues(
          <String, dynamic>{favoriteBusStopsKey: busStops});

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);

      await favoritesService.fetchFavoriteBusStops();

      expect(
          favoritesService.isFavoriteBusStop(busStopModelList[0].busStopCode),
          true);

      expect(
          favoritesService.isFavoriteBusStop(busStopModelList[2].busStopCode),
          false);
    });

    test('It returns empty list when no favorites are stored', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{});

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);
      await favoritesService.fetchFavoriteBusStops();

      expect(favoritesService.favoriteBusStops.length, 0);
    });

    test('It stores a bus stop on an empty list', () async {
      final busStops = [
        busStopModelList[0].busStopCode,
        busStopModelList[1].busStopCode,
      ];

      SharedPreferences.setMockInitialValues(<String, dynamic>{});
      final pref = await SharedPreferences.getInstance();

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);
      await favoritesService.toggleFavoriteBusStop(
        busStops[0],
        false,
      );
      await favoritesService.toggleFavoriteBusStop(
        busStops[1],
        false,
      );

      final favoriteBusStops = pref.getStringList(favoriteBusStopsKey);

      expect(favoriteBusStops.length, busStops.length);

      await favoritesService.fetchFavoriteBusStops();

      expect(favoritesService.favoriteBusStops.length, busStops.length);
    });

    test('It stores a bus stop on an existing list', () async {
      final busStops = [
        busStopModelList[0].busStopCode,
        busStopModelList[1].busStopCode,
        busStopModelList[2].busStopCode,
      ];

      SharedPreferences.setMockInitialValues(<String, dynamic>{
        favoriteBusStopsKey: <String>[busStops[0]],
      });
      final pref = await SharedPreferences.getInstance();

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);
      await favoritesService.toggleFavoriteBusStop(
        busStops[1],
        false,
      );
      await favoritesService.toggleFavoriteBusStop(
        busStops[2],
        false,
      );

      final favoriteBusStops = pref.getStringList(favoriteBusStopsKey);

      expect(favoriteBusStops.length, busStops.length);

      await favoritesService.fetchFavoriteBusStops();

      expect(favoritesService.favoriteBusStops.length, busStops.length);
    });

    test('It removes a bus stop from an existing list', () async {
      final busStops = [
        busStopModelList[0].busStopCode,
        busStopModelList[1].busStopCode,
        busStopModelList[2].busStopCode,
      ];
      final busStopStringToBeRemoved = busStops[1];

      SharedPreferences.setMockInitialValues(<String, dynamic>{
        favoriteBusStopsKey: busStops,
      });
      final pref = await SharedPreferences.getInstance();

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);
      await favoritesService.toggleFavoriteBusStop(
        busStopStringToBeRemoved,
        true,
      );

      busStops.remove(busStopStringToBeRemoved);

      // ensure it is removed in Shared Preferences
      final favoriteBusStops = pref.getStringList(favoriteBusStopsKey);
      expect(favoriteBusStops, busStops);

      // ensure it is removed from the provider list
      expect(favoritesService.favoriteBusStops.length, busStops.length);
    });

    test(
        'It returns empty list when a bus stop is removed and no more bus stops are stored',
        () async {
      final busStops = <String>[
        busStopModelList[0].busStopCode,
      ];
      final busStopStringToBeRemoved = busStops[0];

      SharedPreferences.setMockInitialValues(<String, dynamic>{
        favoriteBusStopsKey: busStops,
      });
      final pref = await SharedPreferences.getInstance();

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);
      await favoritesService.toggleFavoriteBusStop(
        busStopStringToBeRemoved,
        true,
      );

      busStops.remove(busStopStringToBeRemoved);

      final favoriteBusStops = pref.getStringList(favoriteBusStopsKey);

      // ensure it is removed in Shared Preferences
      expect(favoriteBusStops.length, 0);

      // ensure it is removed from the return value of the remove function
      expect(favoritesService.favoriteBusStops.length, busStops.length);
    });

    test('It clears the bus stop favorites', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{
        favoriteBusStopsKey: <String>[
          busStopModelList[0].busStopCode,
          busStopModelList[1].busStopCode,
        ],
      });
      final pref = await SharedPreferences.getInstance();

      final favoritesService =
          FavoriteBusStopsServiceProvider(allBusStops: busStopModelList);

      await favoritesService.clearBusStops();

      final favoriteBusStops = pref.getStringList(favoriteBusStopsKey);

      expect(favoriteBusStops, null);
      expect(favoritesService.favoriteBusStops.length, 0);
    });
  });
}
