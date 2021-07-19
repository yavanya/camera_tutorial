import 'package:camera/camera.dart';
import 'package:camera_tutorial/live_static/live_static_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LiveStaticScreen extends StatelessWidget {
  const LiveStaticScreen(this.backList, this.frontRaw, {Key? key})
      : super(
          key: key,
        );
  final List<CameraImage> backList;
  final CameraImage frontRaw;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStaticViewModel>.reactive(
      viewModelBuilder: () => LiveStaticViewModel(backList, frontRaw),
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
                      child: model.finalImages![0],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RotatedBox(
                          quarterTurns: 2, child: model.finalImages![1]),
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
