import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:image/image.dart' as imglib;

class CameraViewModel extends FutureViewModel {
  CameraController? controller;
  bool isSecret = false;
  bool takingPicture = false;
  bool isRear = true;
  bool isComputing = false;
  bool isCantPhoto = false;
  String currentPath = '';
  List<String> images = [];
  List<CameraImage> secretBackImages = [];
  List<CameraImage> secretFrontImages = [];
  List<Image> finalImages = [];
  Directory dir = Directory('');
  List<CameraDescription> cameras = [];
  int count = 0;

  void setCurrentPath(String path) {
    currentPath = path;
    notifyListeners();
  }

  void setCantPhoto() {
    isCantPhoto = !isCantPhoto;
    notifyListeners();
  }

  void clear() {
    images.clear();
    secretBackImages.clear();
    currentBackVideo = '';
    currentFrontVideo = '';
    secretFrontImages.clear();
    notifyListeners();
  }

  Future<void> takePic() async {
    setCantPhoto();
    var file = await controller!.takePicture();

    setCurrentPath(file.path);
    await setLow();
    startStream();
  }

  Future<void> makeVideo() async {
    setCantPhoto();
    var file = await controller!.takePicture();

    print('ZZZZZZZZZZZZZZZ ${file.path}');
    print('ZZZZZZZZZZZZZZZ  ${await file.length()}');

    setCurrentPath(file.path);
    await controller!.startVideoRecording();

    await Future.delayed(
      Duration(milliseconds: 1500),
    );

    var backVideo = await controller!.stopVideoRecording();
    setCurrentBackVideo(backVideo);
    await changeCameraType(ResolutionPreset.high);
    await controller!.startVideoRecording();

    await Future.delayed(
      Duration(milliseconds: 1500),
    );

    var frontVideo = await controller!.stopVideoRecording();
    setCurrentFrontVideo(frontVideo);
    await changeCameraType(ResolutionPreset.high);
    setCantPhoto();
    print('ZZZZZZZZZZZZZZZZZZ ${await frontVideo.length()}');
  }

  var currentBackVideo;

  var currentFrontVideo;

  void setCurrentBackVideo(XFile video) {
    currentBackVideo = video;
    notifyListeners();
  }

  void setCurrentFrontVideo(XFile video) {
    currentFrontVideo = video;
    notifyListeners();
  }

  void controlStreamState() async {
    if (secretBackImages.length > 30 && isRear) {
      await changeCameraType(ResolutionPreset.low);
      startStream();
    }

    if (secretFrontImages.length > 10 && !isRear) {
      await stopStream();
      await changeCameraType(ResolutionPreset.high);
    }

    if (secretBackImages.length > 30 && secretFrontImages.length > 10) {
      secretBackImages.removeAt(0);
      secretBackImages.removeLast();
      await initController(0, ResolutionPreset.high);
      setCantPhoto();
    }
  }

  Future<void> changeCameraType(ResolutionPreset preset) async {
    await controller!.dispose();

    if (isRear) {
      await initController(1, preset);
      isRear = false;
    } else {
      await initController(0, preset);
      isRear = true;
    }
  }

  Future<void> setLow() async {
    await controller!.dispose();
    await initController(0, ResolutionPreset.low);
  }

  Future<void> startStream() async {
    var isStreaming = controller!.value.isStreamingImages;
    if (isStreaming == false) {
      await controller!.startImageStream(
        (image) {
          print(
              '11111111111111111111   REAR: ${secretBackImages.length}   FRONT: ${secretFrontImages.length}');
          controlStreamState();

          if (isRear) {
            secretBackImages.add(image);
          } else {
            secretFrontImages.add(image);
          }
        },
      );
    }
  }

  Future<void> stopStream() async {
    if (controller!.value.isStreamingImages) {
      await controller!.stopImageStream();
    }
    notifyListeners();
  }

  Future<void> initController(int camera, ResolutionPreset preset) async {
    controller = CameraController(
      cameras[camera],
      preset,
    );

    await controller!.initialize();
    await controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    await controller!.setFocusMode(FocusMode.auto);
  }

  List<CameraImage> getFullList() {
    List<CameraImage> list1 = secretBackImages;
    List<CameraImage> list2 = secretFrontImages;
    List<CameraImage> list = list1 + list2;
    return list;
  }

  List<CameraImage> getFrontList() {
    return secretFrontImages;
  }

  List<CameraImage> getBackList() {
    return secretBackImages;
  }

  @override
  Future futureToRun() async {
    cameras = await availableCameras();
    dir = await getApplicationDocumentsDirectory();
    await initController(0, ResolutionPreset.high);
    // await startStream();
  }
}
