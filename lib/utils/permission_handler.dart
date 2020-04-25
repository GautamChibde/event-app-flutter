import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static final PermissionsService instance = PermissionsService();

  Future<bool> requestStoragePermission() async {
    var granted = await Permission.storage.isGranted;
    if (!granted) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }
}
