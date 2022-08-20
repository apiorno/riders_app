import 'package:riders_app/models/active_driver.dart';

class GeofireRepositoryHelper {
  List<ActiveDriver> activeDrivers = [];

  void addDriver(ActiveDriver driver) => activeDrivers.add(driver);
  void removeDriverById(String id) =>
      activeDrivers.removeWhere((element) => element.id == id);
  void updateDriverPosition(ActiveDriver driver) {
    for (var element in activeDrivers) {
      if (element.id == driver.id) {
        element.latitude = driver.latitude;
        element.longitude = driver.longitude;
        break;
      }
    }
  }
}
