import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'bus_route_model.freezed.dart';
part 'bus_route_model.g.dart';

@freezed

/// Freezed model of BusRouteModel
class BusRouteModel with _$BusRouteModel {
  /// Factory constructor for freezed model
  factory BusRouteModel({
    @JsonKey(name: 'ServiceNo') required String serviceNo,
    @JsonKey(name: 'Operator') required String busOperator,
    @JsonKey(name: 'Direction') required int direction,
    @JsonKey(name: 'StopSequence') required int stopSequence,
    @JsonKey(name: 'BusStopCode') required String busStopCode,
    @JsonKey(name: 'Distance') required double distance,
    @JsonKey(name: 'WD_FirstBus') required String wdFirstBus,
    @JsonKey(name: 'WD_LastBus') required String wdLastBus,
    @JsonKey(name: 'SAT_FirstBus') required String satFirstBus,
    @JsonKey(name: 'SAT_LastBus') required String satLastBus,
    @JsonKey(name: 'SUN_FirstBus') required String sunFirstBus,
    @JsonKey(name: 'SUN_LastBus') required String sunLastBus,
  }) = _BusRouteModel;

  /// Named constructor to convert from Json to a proper model
  factory BusRouteModel.fromJson(Map<String, dynamic> json) =>
      _$BusRouteModelFromJson(json);
}
