import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:lta_datamall_flutter/models/bus_stops/bus_stop_model.dart';
import 'package:lta_datamall_flutter/screens/bus/bus_stops/bus_stop_card_list.dart';
import 'package:lta_datamall_flutter/services/bus/nearby_bus_stops_service_provider.dart';
import 'package:provider/provider.dart';

class NearbyBusStops extends StatefulWidget {
  @override
  _NearbyBusStopsState createState() => _NearbyBusStopsState();
}

class _NearbyBusStopsState extends State<NearbyBusStops> {
  StreamSubscription<Position> positionStream;
  List<BusStopModel> busStopList = <BusStopModel>[];
  final Geolocator geolocator = Geolocator();
  final LocationOptions locationOptions = LocationOptions(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  @override
  void initState() {
    positionStream = geolocator.getPositionStream(locationOptions).listen(
      (Position position) {
        Provider.of<NearbyBusStopsServiceProvider>(context, listen: false)
            .setNearbyBusStop(position);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<BusStopModel> busStopList =
        Provider.of<NearbyBusStopsServiceProvider>(context).nearbyBusStops;
    if (busStopList.isNotEmpty) {
      return BusStopCardList(
        busStopList: busStopList,
      );
    } else {
      return Container();
    }
  }
}
