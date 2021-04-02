import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import '../../routing/router.gr.dart';
import 'models/bus_stop_model.dart';

/// Shows a single card for bus stop information
class BusStopCard extends StatelessWidget {
  /// The constructor for the BusStopCard
  const BusStopCard({
    Key? key,
    required this.busStopModel,
    this.searchTerm = '',
  }) : super(key: key);

  /// bus stop information
  final BusStopModel busStopModel;

  /// search string that is used to highlight text a user has searched for
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    final words = {
      searchTerm: HighlightedWord(
        onTap: () {},
        textStyle: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(color: Theme.of(context).accentColor),
      ),
    };

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: TextHighlight(
                    text: busStopModel.description ?? '',
                    words: words as LinkedHashMap<String, HighlightedWord>,
                  ),
                ),
                TextHighlight(
                  text: '${busStopModel.busStopCode} | '
                      '${busStopModel.roadName}',
                  words: words,
                )
              ],
            ),
          ),
          if (busStopModel.distanceInMeters != null)
            Center(
              child: Text(
                '${busStopModel.distanceInMeters.toString()} m',
                style: const TextStyle(fontSize: 15),
              ),
            )
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).primaryColor,
      ),
      onTap: () {
        context.router.push(
          BusArrivalViewRoute(
            busStopCode: busStopModel.busStopCode,
            description: busStopModel.description ?? '',
          ),
        );
      },
    );
  }
}
