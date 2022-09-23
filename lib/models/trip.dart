class Trip {
  String time;
  String originAddress;
  String destinationAddress;
  String status;
  String fareAmount;
  String carDetails;
  String driverName;

  Trip(this.time, this.originAddress, this.destinationAddress, this.status,
      this.fareAmount, this.carDetails, this.driverName);

  factory Trip.fromJson(Map<String, dynamic> jsonData) {
    return Trip(
        jsonData['time'].toString(),
        jsonData['originAddress'].toString(),
        jsonData['destinationAddress'].toString(),
        jsonData['status'].toString(),
        jsonData['fareAmount'].toString(),
        jsonData['car_details'].toString(),
        jsonData['driver_name'].toString());
  }
}
