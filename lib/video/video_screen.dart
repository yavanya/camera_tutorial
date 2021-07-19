import 'package:camera/camera.dart';
import 'package:camera_tutorial/video/video_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen(this.backFile, this.frontFile, {Key? key})
      : super(
          key: key,
        );
  final XFile backFile;
  final XFile frontFile;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoViewmodel>.reactive(
      viewModelBuilder: () => VideoViewmodel(backFile, frontFile),
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
                      'Обработка видео',
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
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 600,
                      child: Stack(
                        children: [
                          VideoPlayer(model.backController!),
                          Align(
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                            child: SelectableText(
                                                'SIZE: ${model.backSize}')),
                                      );
                                    });
                              },
                              child: Icon(Icons.info),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                onPressed: () => model.backController!.play(),
                                child: Icon(
                                  Icons.play_arrow,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 600,
                      child: Stack(
                        children: [
                          VideoPlayer(model.frontController!),
                          Align(
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                            child: SelectableText(
                                                'SIZE: ${model.frontSize}')),
                                      );
                                    });
                              },
                              child: Icon(Icons.info),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  model.frontController!.play();
                                },
                                child: Icon(
                                  Icons.play_arrow,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
