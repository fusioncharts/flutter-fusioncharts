import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum RequestStatus { retry, init, granted, inProgress, denied }

class PermissionManager {
  static final PermissionManager _singleton = PermissionManager._internal();

  factory PermissionManager() {
    return _singleton;
  }

  PermissionManager._internal();

  bool requestGranted = false;
  Directory? directory;
  RequestStatus requestStatus = RequestStatus.init;

  Future<RequestStatus> requestPermission() async {
    if (requestStatus == RequestStatus.granted ||
        requestStatus == RequestStatus.denied ||
        requestStatus == RequestStatus.inProgress) {
      return requestStatus;
    } else {
      requestStatus = RequestStatus.inProgress;
      return (await _getStoragePermission());
    }
  }

  Future<RequestStatus> _getStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.accessMediaLocation,
          Permission.manageExternalStorage,
          Permission.storage,
        ].request();

        print(statuses[Permission.storage]);

        statuses.forEach((key, value) {
          if ((value == PermissionStatus.denied) ||
              (value == PermissionStatus.permanentlyDenied)) {
            requestStatus = RequestStatus.denied;
          }
        });
        if (requestStatus == RequestStatus.denied) return requestStatus;
        requestStatus == RequestStatus.granted;
        directory = await getExternalStorageDirectory();
        if (directory == null) return RequestStatus.denied;
        String newPath = "";
        print(directory);
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/fusion_charts";
        directory = Directory(newPath);
      } else {
        if ((await Permission.photos.request()) == PermissionStatus.granted) {
          requestStatus = RequestStatus.granted;
          directory = await getTemporaryDirectory();
          if (directory != null) {
            if (!await directory!.exists()) {
              await directory!.create(recursive: true);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return requestStatus;
  }
}
