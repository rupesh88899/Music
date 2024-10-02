import 'package:permission_handler/permission_handler.dart';

permissionChecker() async {
  var status = await Permission.storage.status;

  if (!status.isGranted) {
    status = await Permission.manageExternalStorage.request();
  }

  if (status.isGranted) {
    print("Storage Permission Granted");
    // Proceed with file operations
  } else if (status.isDenied || status.isPermanentlyDenied) {
    print("Storage Permission Denied");
    // Handle denied permission (show user a message or settings page)
  }
}
