import 'dart:io';

import 'package:camera/camera.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoViewmodel extends FutureViewModel {
  VideoViewmodel(this.backXFile, this.frontXFile);
  final XFile backXFile;
  final XFile frontXFile;

  var backData = {};

  var frontData = {};

  int backSize = 0;

  int frontSize = 0;

  // final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  // final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();

  VideoPlayerController? backController;

  VideoPlayerController? frontController;

  // Future<void> encode264() async {
  //   var video = _flutterFFmpeg.execute('');
  // }

  @override
  Future futureToRun() async {
    var backFile = File(backXFile.path);

    var frontFile = File(frontXFile.path);

    backSize = await backXFile.length();

    frontSize = await frontXFile.length();

    backController = VideoPlayerController.file(backFile);

    frontController = VideoPlayerController.file(frontFile);

    // await _flutterFFprobe
    //     .getMediaInformation('${backXFile.path}')
    //     .then((value) => backData = value.getAllProperties());

    // await Future.delayed(Duration(milliseconds: 200));

    // await _flutterFFprobe
    //     .getMediaInformation('${frontXFile.path}')
    //     .then((value) => frontData = value.getAllProperties());

    await backController!.initialize();

    await frontController!.initialize();
  }
}
