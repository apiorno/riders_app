import 'package:firebase_database/firebase_database.dart';

class Rider {
  String? phone;
  String? name;
  String? id;
  String? email;

  Rider({this.phone, this.name, this.id, this.email});

  Rider.fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value as dynamic;
    phone = value['phone'];
    name = value['name'];
    id = snapshot.key;
    email = value['email'];
  }
}
