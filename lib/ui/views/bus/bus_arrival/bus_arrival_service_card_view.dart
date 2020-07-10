import 'package:flutter/material.dart';
import 'package:lta_datamall_flutter/ui/views/shared/tag/tag.dart';
import 'package:lta_datamall_flutter/datamodels/bus/bus_arrival/bus_arrival_service_model.dart';

class BusArrivalServiceCardView extends StatelessWidget {
  const BusArrivalServiceCardView({
    Key key,
    @required this.busArrivalServiceModel,
  }) : super(key: key);

  final BusArrivalServiceModel busArrivalServiceModel;

  String getTimeToBusStop(String arrivalTime, [bool isSuffixShown = false]) {
    if (arrivalTime == '') {
      return 'n/a';
    }

    final suffix = isSuffixShown && isSuffixShown ? 'min' : '';

    final arrivalInMinutes =
        DateTime.parse(arrivalTime).difference(DateTime.now()).inMinutes;

    return arrivalInMinutes <= 0
        ? 'Arr'
        : '${arrivalInMinutes.toString()}$suffix';
  }

  String _getBusLoad(dynamic load) {
    final _busLoad = {
      'SEA': 'Seats Available',
      'SDA': 'Standing Available',
      'LSD': 'Limited Standing',
    };

    return load == '' ? '' : _busLoad[load];
  }

  String _busTypes(dynamic type) {
    final _busType = {
      'SD': 'Single Deck',
      'DD': 'Double Deck',
      'BD': 'Bendy',
    };

    return _busType[type];
  }

  Widget _displayBusFeature() {
    if (busArrivalServiceModel.nextBus.feature != 'WAB') {
      return const Text('');
    }

    return Icon(
      Icons.accessible,
      size: 22.0,
    );
  }

  Widget _displayNextBusTiming() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        getTimeToBusStop(busArrivalServiceModel.nextBus.estimatedArrival, true),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _displayNotInOperation() {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      child: Text(
        'Not In\nOperation',
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _displayNextTwoBusTiming() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '${getTimeToBusStop(busArrivalServiceModel.nextBus2.estimatedArrival)}, ${getTimeToBusStop(busArrivalServiceModel.nextBus3.estimatedArrival)}',
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Bus ${busArrivalServiceModel.serviceNo}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                    busArrivalServiceModel.inService ?? true
                        ? Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Tag(
                                  text: _getBusLoad(
                                    busArrivalServiceModel.nextBus.load,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Tag(
                                  text: _busTypes(
                                    busArrivalServiceModel.nextBus.type,
                                  ),
                                ),
                                _displayBusFeature()
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: busArrivalServiceModel.inService ?? true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _displayNextBusTiming(),
                            _displayNextTwoBusTiming()
                          ],
                        )
                      : Center(
                          child: Container(
                            child: _displayNotInOperation(),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
