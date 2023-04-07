// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';

// enum InternetConnectionStatus {
//   connected,
//   disconnected,
// }

// class InternetConnectionProvider extends ChangeNotifier {
//   InternetConnectionStatus _status = InternetConnectionStatus.disconnected;

//   InternetConnectionStatus get status => _status;

//   void checkInternetConnectivity() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());

//     if (connectivityResult == ConnectivityResult.none) {
//       _status = InternetConnectionStatus.disconnected;
//     } else {
//       _status = InternetConnectionStatus.connected;
//     }

//     notifyListeners();
//   }
// }
