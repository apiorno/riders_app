class ActiveDriver {
  String id;
  double latitude;
  double longitude;

  ActiveDriver(
      {required this.id, required this.latitude, required this.longitude});
  factory ActiveDriver.fromJson(Map<String, dynamic> jsonData) => ActiveDriver(
      id: jsonData['key'],
      latitude: jsonData['latitude'],
      longitude: jsonData['longitude']);
}
