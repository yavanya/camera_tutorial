import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image/image.dart' as imglib;

typedef convert_func = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);

typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);

List<Image> computeImages(List<List<CameraImage>> rawList) {
  final DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();

  Convert conv = convertImageLib
      .lookup<NativeFunction<convert_func>>('convertImage')
      .asFunction<Convert>();

  imglib.Image convertImage(CameraImage raw) {
    imglib.Image img;

    if (Platform.isAndroid) {
      Pointer<Uint8> p = calloc(raw.planes[0].bytes.length);
      Pointer<Uint8> p1 = calloc(raw.planes[1].bytes.length);
      Pointer<Uint8> p2 = calloc(raw.planes[2].bytes.length);

      Uint8List pointerList = p.asTypedList(raw.planes[0].bytes.length);
      Uint8List pointerList1 = p1.asTypedList(raw.planes[1].bytes.length);
      Uint8List pointerList2 = p2.asTypedList(raw.planes[2].bytes.length);
      pointerList.setRange(0, raw.planes[0].bytes.length, raw.planes[0].bytes);
      pointerList1.setRange(0, raw.planes[1].bytes.length, raw.planes[1].bytes);
      pointerList2.setRange(0, raw.planes[2].bytes.length, raw.planes[2].bytes);

      Pointer<Uint32> imgP = conv(p, p1, p2, raw.planes[1].bytesPerRow,
          raw.planes[1].bytesPerPixel!, raw.planes[0].bytesPerRow, raw.height);

      List<int> imgData =
          imgP.asTypedList((raw.planes[0].bytesPerRow * raw.height));

      img = imglib.Image.fromBytes(
          raw.height, raw.planes[0].bytesPerRow, imgData);

      calloc.free(p);
      calloc.free(p1);
      calloc.free(p2);
      calloc.free(imgP);
    } else {
      img = imglib.Image.fromBytes(
        raw.planes[0].bytesPerRow,
        raw.height,
        raw.planes[0].bytes,
        format: imglib.Format.bgra,
      );
    }
    return img;
  }

  var backImages = <imglib.Image>[];

  var frontImages = <imglib.Image>[];

  var imageWidgets = <Image>[];

  var rawBack = rawList[0];

  var rawFront = rawList[1];

  rawBack.forEach((element) {
    imglib.Image image;

    image = convertImage(element);

    backImages.add(image);
  });

  rawFront.forEach((element) {
    imglib.Image image;

    image = convertImage(element);

    frontImages.add(image);
  });

  var backAnim = imglib.Animation()..frames = backImages;

  var frontAnim = imglib.Animation()..frames = frontImages;

  var backGif = imglib.encodeGifAnimation(backAnim) as Uint8List;

  var frontGif = imglib.encodeGifAnimation(frontAnim) as Uint8List;

  var backGifWidget = Image.memory(backGif);

  var frontGifWidget = Image.memory(frontGif);

  imageWidgets.addAll([backGifWidget, frontGifWidget]);

  return imageWidgets;
}

class LiveLiveViewModel extends FutureViewModel {
  LiveLiveViewModel(this.rawBackList, this.rawFrontList);
  final List<CameraImage> rawBackList;
  final List<CameraImage> rawFrontList;

  // bool isComputing = false;

  List<Image>? imageWidgets;

  Future<void> runCompute() async {
    List<List<CameraImage>> rawList1 = [rawBackList, rawFrontList];

    imageWidgets = await compute(computeImages, rawList1);

    notifyListeners();
  }

  @override
  Future futureToRun() async {
    await runCompute();
  }
}
