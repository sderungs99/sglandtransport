import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../routing/router.gr.dart' as auto_route;
import 'models/bus_stop_model.dart';

/// Shows a single card for bus stop information
class BusStopCard extends StatelessWidget {
  /// The constructor for the BusStopCard
  const BusStopCard({
    Key key,
    @required this.busStopModel,
    this.searchTerm = '',
  }) : super(key: key);

  /// bus stop information
  final BusStopModel busStopModel;

  /// search string that is used to highlight text a user has searched for
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 12),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: SubstringHighlight(
                        text: busStopModel.description,
                        term: searchTerm,
                        textStyle: Theme.of(context).textTheme.headline1,
                        textStyleHighlight: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                    ),
                    SubstringHighlight(
                      text: '${busStopModel.busStopCode} | '
                          '${busStopModel.roadName}',
                      term: searchTerm,
                      textStyle: Theme.of(context).textTheme.headline2,
                      textStyleHighlight: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
              ),
            ),
            busStopModel.distanceInMeters != null
                ? Center(
                    child: Text(
                      '${busStopModel.distanceInMeters.toString()} m',
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                : Text('')
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () {
          ExtendedNavigator.root.push(auto_route.Routes.busArrivalView,
              arguments: auto_route.BusArrivalViewArguments(
                busStopCode: busStopModel.busStopCode,
                description: busStopModel.description,
              ));
        },
      ),
    );
  }
}