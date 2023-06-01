import 'package:location/location.dart';

class GenericOps {
  static int cCANTMINPASS = 8;

  static bool checkValidEmail(String email) {
    RegExp expr =
        RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9\.\-_]+@[a-zA-Z0-9]+(\.[a-z0-9]+)+$');
    bool match = expr.hasMatch(email);
    return match;
  }

  static bool checValidFloat(String fltNmbr) {
    RegExp expr = RegExp(r'^[0-9][0-9]*$|^[0-9][0-9]*\.[0-9]+$');
    bool resp = expr.hasMatch(fltNmbr);
    return resp;
  }

  static bool checkValidEntero(String nro) {
    RegExp expr = RegExp(r"^[1-9][0-9]*$|^[0-9]$");
    bool resp = expr.hasMatch(nro);
    return resp;
  }

  static Future<bool> handleLocationPermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.denied) {
          return false;
        }
      }
      return true;
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.denied) {
          return false;
        }
        return true;
      } else {
        return true;
      }
    }
  }
}
