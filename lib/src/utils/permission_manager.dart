import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

enum RequestStatus { init, granted, inProgress, denied }

class PermissionManager {
  static final PermissionManager _singleton = PermissionManager._internal();

  factory PermissionManager() {
    return _singleton;
  }

  PermissionManager._internal();

  bool requestGranted = false;
  bool isPDFGen = false;
  String jpgFileName = '';
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
//      print(e);
    }
    return requestStatus;
  }

  late Uint8List base64decode;
  late String fileExtension;
  late File exportFile;

  /// showSnack is the funtion that is invoked when the file is downloaded or when the
  /// download permission is not given and the user is trying to export the file
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

  ///The file name variable is initialised with suggested file name from the download request callback of the in app web view
  decode(request, type, context, fcController) async {
    fileExtension = request.suggestedFilename.toString().split('.')[1];

    if (fileExtension == 'svg' ||
        fileExtension == 'png' ||
        fileExtension == 'jpg') {
      base64decode = base64.decode(request.url.toString().split(';base64,')[1]);
    } else if (fileExtension == 'pdf') {
      isPDFGen = true;
      fcController.executeScript("""globalFusionCharts.exportChart({
        "exportFormat": "jpg",
        });""");
      return;
    } else {
      // var blobUrl = request.url.toString().split('/')[1];

      String blobUrl = request.url.toString();
      if (blobUrl.contains('blob')) {
        //   base64decode = base64.decode(request.url.toString().split(';base64,')[1]);
        String xhr = """
            var xhr = new XMLHttpRequest(); 
              xhr.responseType = 'blob';
             xhr.onload = function() {
                  var recoveredBlob = xhr.response;

                  var reader = new FileReader;

                  reader.onload = function() {
                    var blobAsDataUrl = reader.result;
                    window.location = blobAsDataUrl;
                  };

                  reader.readAsDataURL(recoveredBlob);
                };

                xhr.open('GET', '$blobUrl');
                xhr.send();
              """;

        ///The file name is checked accordingly and the data that comes with it is decoded accordingly

        await fcController.executeScript(xhr);
        return;
        // base64decode = base64.decode(request.url.toString().split('/')[1]);
      } else {
        base64decode =
            base64.decode(request.url.toString().split(';base64,')[1]);
        print(base64decode);
      }
    }

    ///Save file is called to save the file after decoding the data
    await saveFile(context, type);
  }

  createFolder() async {
    try {
      ///This is the name of the folder that is created on the device when user exports charts
      String folderName = "fusionCharts";

      ///Path of the folder name

      final savedDir = Platform.isAndroid
          ? Directory("storage/emulated/0/$folderName")
          : getLocalPath();

      if ((await savedDir.exists())) {
      } else {
        savedDir.create();
      }
      return savedDir.path;
    } catch (e) {
      // print(e.message);
    }
  }

  getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  localFile(type) async {
    final path = await createFolder();
    return File('$path/$type.$fileExtension');
  }

  /// saveFile saves the downloaded file into the external storage
  saveFile(context, type) async {
    try {
      /// here the permission request is checked if it is granted or not
      /// to save the file the permission to write in external storage should be given
      if (PermissionManager().requestStatus == RequestStatus.denied) {
        showSnack('Permission denied for storage', context);
      } else {
        /// path of the folder where the imports will be saved
        final file = await createFolder();

        exportFile = await File('$file/$type${"_${DateTime.now().millisecondsSinceEpoch}"}.$fileExtension')
            .writeAsBytes(base64decode, flush: true);
        if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
          final path = await createFolder();

          jpgFileName = '$path/$type.$fileExtension';

          if (isPDFGen) {
            final pdf = pw.Document();
            final image = pw.MemoryImage(File(jpgFileName).readAsBytesSync());
            fileExtension = "pdf";

            pdf.addPage(
              pw.Page(
                build: (pw.Context context) => pw.Center(
                  child: pw.Image(image),
                ),
              ),
            );
            final file = File('$path/$type${"_${DateTime.now().millisecondsSinceEpoch}"}.$fileExtension');
            await file.writeAsBytes(await pdf.save());
            await exportFile.delete();
            isPDFGen = false;
          }
        }

        showSnack('Downloaded $type.$fileExtension', context);
      }
    } catch (e) {
      // print(e.message);
    }
  }
}
