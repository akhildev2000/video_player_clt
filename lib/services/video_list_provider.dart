import 'dart:io';
import 'package:flutter/material.dart';
import '../models/videos.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class VideoListProvider extends ChangeNotifier {
  final List<Videos> _videoList = [
    //video1
    Videos(
        videoName: 'Video 1',
        videoSrc:
            'https://drive.google.com/uc?export=download&id=1qZORtY8I8p90NANTE9S8MjcjWSrEDnwr'),

    //video2
    Videos(
        videoName: 'Video 2',
        videoSrc:
            'https://drive.google.com/uc?export=download&id=1qZORtY8I8p90NANTE9S8MjcjWSrEDnwr'),
    //video3
    Videos(
        videoName: 'Video 3',
        videoSrc:
            'https://drive.google.com/uc?export=download&id=1qZORtY8I8p90NANTE9S8MjcjWSrEDnwr'),
  ];
//current video index
  int? _currentVideoIndex;

//current video src
  String? _currentVideoSrc;

  //getters
  List<Videos> get videosList => _videoList;
  int? get currentVideoIndex => _currentVideoIndex;
  String? get currentVideoSrc => _currentVideoSrc;

  //setters
  set currentVideoIndex(int? newIndex) {
    //update current video index
    _currentVideoIndex = newIndex;
    //update ui
    notifyListeners();
  }

  set currentVideoSrc(String? newSrc) {
    _currentVideoSrc = newSrc;
    notifyListeners();
  }

  //download video
  Future<void> downloadVideo(int index) async {
    final video = _videoList[index];
    final encryptedVideoName = 'encrypted_${video.videoName}.mp4';
    final status = await FlutterDownloader.enqueue(
      url: video.videoSrc,
      savedDir: (await getApplicationDocumentsDirectory()).path,
      fileName: encryptedVideoName,
      showNotification: true,
      openFileFromNotification: true,
    );
    if (status == DownloadTaskStatus.complete) {
      encryptVideo(encryptedVideoName);
    }
  }

  //encrypt video
  void encryptVideo(String videoName) {
    final video = File(videoName);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(encrypt.Key(encrypt.decodeHexString('video'))));
    final encryptedFile = File('${video.path}.encrypted');
    final encrypted = encrypter.encryptBytes(video.readAsBytesSync());
    encryptedFile.writeAsBytesSync(encrypted.bytes);
    video.deleteSync();
  }
}
