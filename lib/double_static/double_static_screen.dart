import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_tutorial/double_static/double_static_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DoubleStaticScreen extends StatelessWidget {
  const DoubleStaticScreen(this.cameraImage, this.path, {Key? key})
      : super(
          key: key,
        );
  final CameraImage cameraImage;
  final String path;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DoubleStaticViewModel>.reactive(
      viewModelBuilder: () => DoubleStaticViewModel(cameraImage),
      builder: (context, model, child) {
        if (model.isBusy) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Обработка изображений',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(path),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          RotatedBox(quarterTurns: 2, child: model.frontImage!),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
