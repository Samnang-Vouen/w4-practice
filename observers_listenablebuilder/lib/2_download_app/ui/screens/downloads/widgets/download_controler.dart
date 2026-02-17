import 'package:flutter/material.dart';

class Ressource {
  final String name;
  final int size; // in MB

  Ressource({required this.name, required this.size});
}

enum DownloadStatus { notDownloaded, downloading, downloaded }

class DownloadController extends ChangeNotifier {
  DownloadController(this.ressource);

  // DATA
  Ressource ressource;
  DownloadStatus _status = DownloadStatus.notDownloaded;
  double _progress = 0.0; // 0.0 → 1.0

  // GETTERS
  DownloadStatus get status => _status;
  double get progress => _progress;

  // ACTIONS
  void startDownload() async {
    if (_status == DownloadStatus.downloading) return;
    // TODO
    // 1 – set status to downloading
    // 2 – Loop 10 times and increment the download progress (0 -> 0.1 -> 0.2 )
    //      - Wait 1 second :  await Future.delayed(const Duration(milliseconds: 1000));

    // 3 – set status to downloaded
    _status = DownloadStatus.downloading;
    _progress = 0.0;
    notifyListeners();

    for (var i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _progress = i / 10;
      notifyListeners();
    }

    _status = DownloadStatus.downloaded;
    notifyListeners();
  }
}
