import 'package:flutter/foundation.dart';
import 'package:riders_app/models/directions_address.dart';
import 'package:riders_app/models/trip.dart';

class AppInfo extends ChangeNotifier {
  DirectionsAddress? userPickUpLocation;
  DirectionsAddress? userDropOffLocation;
  int totalTripsCount = 0;
  List<String> historyTripsKeys = [];
  List<Trip> tripsHistory = [];

  void updatePickUpLocationAddress(DirectionsAddress newUserPickUpAddress) {
    userPickUpLocation = newUserPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(DirectionsAddress newUserDropOffAddress) {
    userDropOffLocation = newUserDropOffAddress;
    notifyListeners();
  }

  void updateOverAllTripsCount(int newTotalTripsCount) {
    totalTripsCount = newTotalTripsCount;
  }

  void updateOverAllTripsKeys(List<String> keys) {
    historyTripsKeys = keys;
  }

  void updateOverAllTripsHistoryInformation(Trip trip) {
    tripsHistory.add(trip);
  }
}
