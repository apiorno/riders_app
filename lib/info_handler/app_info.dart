import 'package:flutter/foundation.dart';
import 'package:riders_app/models/directions_address.dart';

class AppInfo extends ChangeNotifier {
  DirectionsAddress? userPickUpLocation;
  DirectionsAddress? userDropOffLocation;

  void updatePickUpLocationAddress(DirectionsAddress newUserPickUpAddress) {
    userPickUpLocation = newUserPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(DirectionsAddress newUserDropOffAddress) {
    userDropOffLocation = newUserDropOffAddress;
    notifyListeners();
  }
}
