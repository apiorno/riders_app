import 'dart:convert';
import 'dart:js';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/helpers/request_helper.dart';
import 'package:riders_app/info_handler/app_info.dart';
import 'package:riders_app/models/direction_details_info.dart';
import 'package:riders_app/models/directions_address.dart';
import 'package:riders_app/models/rider.dart';
import 'package:riders_app/models/trip.dart';

class RepositoryHelper {
  static Future<String> searchAddressForGeographicCoordinates(
      Position position, BuildContext context) async {
    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var resultAddress = '';
    try {
      final response = await RequestHelper.receiveRequest(apiUrl);
      resultAddress = response['results'][0]['formatted_address'];
      final userPickupAddress = DirectionsAddress(
          locationLatitude: position.latitude,
          locationLongitude: position.longitude,
          locationName: resultAddress);

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocationAddress(userPickupAddress);
    } catch (e) {
      resultAddress = '';
    }
    return resultAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference riderRef = FirebaseDatabase.instance
        .ref()
        .child('riders')
        .child(currentFirebaseUser!.uid);
    riderRef.once().then((riderKey) {
      final snapshot = riderKey.snapshot;
      if (snapshot.value != null) {
        currentRider = Rider.fromSnapshot(snapshot);
      }
    });
  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(
      LatLng origin, LatLng destination) async {
    final response = await RequestHelper.receiveRequest(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey');

    return DirectionDetailsInfo.fromJson(response['routes'][0]);
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetailsInfo? directionDetailsInfo) {
    if (directionDetailsInfo == null) return 0;
    double timeTraveledFarePerMinute =
        (directionDetailsInfo.durationValue! / 60) * 0.1;
    double distanceTraveledFarePerKilometer =
        (directionDetailsInfo.durationValue! / 1000) * 0.1;
    return double.parse(
        (timeTraveledFarePerMinute + distanceTraveledFarePerKilometer)
            .toStringAsFixed(1));
  }

  static sendNotificationToDriver(String deviceRegistrationToken,
      String userRideRequestId, BuildContext context) {
    final header = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };
    final body = {
      'body': 'Destination address $userDropoffAddress',
      'title': 'New Trip Request'
    };
    final dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'rideRequestId': userRideRequestId
    };
    final officialNotification = {
      'notification': body,
      'data': dataMap,
      'priority': 'high',
      'to': deviceRegistrationToken
    };
    final response = http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: header, body: jsonEncode(officialNotification));
  }

  static void readTripsKeysForOlineUser(context) {
    FirebaseDatabase.instance
        .ref()
        .child('rideRequests')
        .orderByChild('userName')
        .equalTo(currentRider!.name)
        .once()
        .then((snap) {
      final val = snap.snapshot.value;
      if (val != null) {
        final overAllTripsCount = (val as Map<String, dynamic>).length;
        Provider.of<AppInfo>(context, listen: false)
          ..updateOverAllTripsCount(overAllTripsCount)
          ..updateOverAllTripsKeys(val.keys.toList());

        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    final rideRequestsRef =
        FirebaseDatabase.instance.ref().child('rideRequests');
    final appInfo = Provider.of<AppInfo>(context, listen: false);
    appInfo.historyTripsKeys.forEach((tripKey) {
      rideRequestsRef.child(tripKey).once().then((snap) {
        final trip = Trip.fromJson(snap.snapshot.value as Map<String, dynamic>);
        appInfo.updateOverAllTripsHistoryInformation(trip);
      });
    });
  }
}
