// import 'package:flare_flutter/flare_cache.dart';
// import 'package:flare_flutter/flare_testing.dart';
// import 'package:flare_flutter/provider/asset_flare.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_driver/driver_extension.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:location/location.dart';
// import 'package:logging/logging.dart';
// import 'package:lta_datamall_flutter/app/bus/bus_nearby_view.dart';
// import 'package:lta_datamall_flutter/common_widgets/sliver_view.dart';
// import 'package:lta_datamall_flutter/my_app.dart';
// import 'package:lta_datamall_flutter/services/local_storage_service.dart';
// import 'package:lta_datamall_flutter/services/provider_logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> warmupFlare() async {
//   await cachedActor(AssetFlare(bundle: rootBundle, name: 'images/city.flr'));
// }

// Future<void> main() async {
//   WidgetsApp.debugAllowBannerOverride = false;
//   FlareTesting.setup();
//   enableFlutterDriverExtension();
//   WidgetsFlutterBinding.ensureInitialized();

//   final sharedPreferences = await SharedPreferences.getInstance();

//   FlareCache.doesPrune = false;

//   final logLevel = Level.WARNING;

//   Logger.root.level = logLevel;
//   Logger.root.onRecord.listen((record) {
//     // ignore: avoid_print
//     print('[${record.loggerName}]: ${record.level.name}: '
//         '${record.time}: ${record.message}');
//   });

//   final fakeLocationStreamProvider =
//       StreamProvider.autoDispose<LocationData>((ref) {
//     return Stream.value(
//       LocationData.fromMap(
//         {
//           'latitude': 1.29685,
//           'longitude': 103.853,
//         },
//       ),
//     );
//   });

//   await warmupFlare();
//   runApp(ProviderScope(
//     overrides: [
//       locationStreamProvider.overrideWithProvider(
//         fakeLocationStreamProvider,
//       ),
//       isFlareAnimationLoopStateProvider
//           .overrideWithValue(StateController(false)),
//       localStorageServiceProvider.overrideWithValue(
//         LocalStorageService(sharedPreferences),
//       )
//     ],
//     observers: [ProviderLogger()],
//     child: const MyApp(),
//   ));
// }
