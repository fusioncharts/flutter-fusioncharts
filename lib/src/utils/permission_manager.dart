import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum RequestStatus { init, granted, inProgress, denied }

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

  late Uint8List base64decode;
  late String fileName;
  var data;

  void showSnack(String title, context) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  /// This is the snackbar funtion that is invoked when the file is downloaded or when the
  /// download permission is not given and the user is trying to export the file

  decode(request, type, context) {
    fileName = request.suggestedFilename.toString().split('.')[1];

    ///The file name variable is initialised with suggested file name from the download request callback of the in app web view

    if (fileName == 'svg' ||
        fileName == 'png' ||
        fileName == 'jpg' ||
        fileName == 'pdf') {
      base64decode = base64.decode(request.url.toString().split(';base64,')[1]);
    } else {
      base64decode = base64.decode(request.url.toString().split('/')[1]);
    }

    print(request.url);
    print(request);

    ///The file name is checked accordingly and the data that comes with it is decoded accordingly

    saveFile(context, type);

    ///Save file is called to save the file after decoding the data
  }

  createFolder() async {
    try {
      String folderName = "fusionCharts";

      ///This is the name of the folder that is created on the device when user exports charts

      final path = Directory("storage/emulated/0/$folderName");

      ///Path of the folder name

      if ((await path.exists())) {
      } else {
        path.create();
      }
      return path.path;
    } catch (e) {
      // print(e.message);
    }
  }

  saveFile(context, type) async {
    try {
      /// saveFile saves the downloaded file into the external storage

      if (PermissionManager().requestStatus == RequestStatus.denied) {
        /// here the permission request is checked if it is granted or not
        /// to save the file the permission to write in external storage should be given

        showSnack('Permission denied for storage', context);

        ///Snackbar alert when the permission is not given

      } else {
        final path = await createFolder();

        /// path of the folder where the imports will be saved

        data = await File('$path/$type.$fileName')
            .writeAsBytes(base64decode, flush: true);

        showSnack('Downloaded $type', context);

        /// Snackbar alert is shown once the file is created

      }
    } catch (e) {
      // print(e.message);
    }
  }
}
