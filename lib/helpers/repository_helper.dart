import 'package:firebase_database/firebase_database.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/models/rider.dart';

class RepositoryHelper {
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
}
