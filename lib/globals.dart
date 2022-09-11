import 'package:firebase_auth/firebase_auth.dart';
import 'package:riders_app/models/direction_details_info.dart';
import 'package:riders_app/models/rider.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
String mapKey = 'MyApiKey';
Rider? currentRider;
List availableDrivers = [];
DirectionDetailsInfo? tripDirectionsInfo;
String chosenDriverId = '';
String cloudMessagingServerToken = 'ServerToken';
late String userDropoffAddress;
