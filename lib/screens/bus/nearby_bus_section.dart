import 'package:flutter/material.dart';
import 'package:lta_datamall_flutter/models/user_location.dart';
import 'package:lta_datamall_flutter/screens/bus/bus_stops/bus_stop_card_list.dart';
import 'package:lta_datamall_flutter/services/bus/nearby_bus_stops_service_provider.dart';
import 'package:provider/provider.dart';

class NearbyBusStops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userLocation = Provider.of<UserLocation>(context);
    if (userLocation != null) {
      final busStopList =
          Provider.of<NearbyBusStopsServiceProvider>(context, listen: false)
              .getNearbyBusStops(userLocation);
      return BusStopCardList(
        busStopList: busStopList,
      );
    } else {
      return Container();
    }
  }
}
