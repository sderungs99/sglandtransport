import 'package:flutter/material.dart';
import 'package:lta_datamall_flutter/datamodels/bus/bus_stop/bus_stop_model.dart';
import 'package:lta_datamall_flutter/ui/views/bus/bus_stop/bus_stop_view_model.dart';
import 'package:lta_datamall_flutter/ui/views/shared/box_info/box_info_view.dart';
import 'package:stacked/stacked.dart';

class BusStopView extends StatelessWidget {
  const BusStopView({
    Key key,
    @required this.busStopModel,
  }) : super(key: key);

  final BusStopModel busStopModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusStopViewModel>.nonReactive(
      builder: (context, model, child) => Card(
        margin: const EdgeInsets.all(6),
        child: ListTile(
          leading: Icon(Icons.departure_board),
          title: Text(busStopModel.description),
          subtitle:
              Text('${busStopModel.busStopCode} | ${busStopModel.roadName}'),
          trailing: busStopModel.distanceInMeters != null
              ? BoxInfo(
                  color: Theme.of(context).highlightColor,
                  child: Column(
                    children: <Widget>[
                      Text(
                        busStopModel.distanceInMeters.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text('meters'),
                    ],
                  ),
                )
              : Icon(Icons.assignment),
          onTap: () {
            model.navigateToBusArrival(
              busStopModel.busStopCode,
              busStopModel.description,
            );
          },
        ),
      ),
      viewModelBuilder: () => BusStopViewModel(),
    );
  }
}