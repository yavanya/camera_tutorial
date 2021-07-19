import 'dart:io';

// import 'package:camera_tutorial/back_live/back_live_screen.dart';
import 'package:camera_tutorial/camera/camera_viewmodel.dart';
// import 'package:camera_tutorial/double_static/double_static_screen.dart';
// import 'package:camera_tutorial/live_live/live_live_screen.dart';
// import 'package:camera_tutorial/live_static/live_static_screen.dart';
import 'package:camera_tutorial/video/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:stacked/stacked.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<CameraViewModel>.reactive(
        viewModelBuilder: () => CameraViewModel(),
        builder: (context, CameraViewModel model, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Builder(
              builder: (context) {
                if (!model.isBusy && model.currentPath.isNotEmpty) {
                  return Center(
                    child: Image.file(
                      File(model.currentPath),
                    ),
                  );
                }

                if (model.isBusy) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Center(
                  child: CameraPreview(model.controller!),
                );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      model.isCantPhoto
                          ? FloatingActionButton(
                              onPressed: () => null,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : model.currentPath.isEmpty
                              ? FloatingActionButton(
                                  heroTag: "btn1",
                                  onPressed: () async {
                                    model.makeVideo();
                                  },
                                  child: Icon(Icons.video_call),
                                )
                              : FloatingActionButton(
                                  heroTag: "btn2",
                                  onPressed: () {
                                    model.clear();
                                    model.setCurrentPath('');
                                  },
                                  child: Icon(Icons.refresh),
                                ),
                      // model.isCantPhoto
                      //     ? FloatingActionButton(
                      //         onPressed: () => null,
                      //         child: CircularProgressIndicator(
                      //           color: Colors.white,
                      //         ))
                      //     : FloatingActionButton(
                      //         heroTag: "btn9",
                      //         onPressed: () async {
                      //           model.makeVideo();
                      //         },
                      //         child: Icon(Icons.video_call),
                      //       ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //   model.getBackList().isNotEmpty
                        //       ? FloatingActionButton(
                        //           heroTag: "btn3",
                        //           onPressed: () async {
                        //             // await model.stopStream();
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) =>
                        //                     BackLiveScreen(model.getBackList()),
                        //               ),
                        //             );
                        //           },
                        //           child: Text('live'),
                        //         )
                        //       : SizedBox(),
                        //   model.getFrontList().isNotEmpty
                        //       ? FloatingActionButton(
                        //           heroTag: "btn4",
                        //           onPressed: () async {
                        //             // await model.stopStream();
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => DoubleStaticScreen(
                        //                     model.getFrontList().last,
                        //                     model.currentPath),
                        //               ),
                        //             );
                        //           },
                        //           child: Text('static'),
                        //         )
                        //       : SizedBox(),
                        //   model.getBackList().isNotEmpty
                        //       ? FloatingActionButton(
                        //           heroTag: "btn5",
                        //           onPressed: () async {
                        //             // await model.stopStream();
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => LiveStaticScreen(
                        //                   model.getBackList(),
                        //                   model.getFrontList().last,
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           child: Text(
                        //             'live + static',
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         )
                        //       : SizedBox(),
                        //   model.getBackList().isNotEmpty
                        //       ? FloatingActionButton(
                        //           heroTag: "btn6",
                        //           onPressed: () async {
                        //             // await model.stopStream();
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => LiveLiveScreen(
                        //                   model.getBackList(),
                        //                   model.getFrontList(),
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           child: Text(
                        //             'live + live',
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         )
                        //       : SizedBox(),
                        model.currentBackVideo != null &&
                                model.currentFrontVideo != null
                            ? FloatingActionButton(
                                heroTag: "btn7",
                                onPressed: () async {
                                  // await model.stopStream();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                          model.currentBackVideo,
                                          model.currentFrontVideo),
                                    ),
                                  );
                                },
                                child: Text(
                                  'live + live',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : SizedBox(),
                      ]),
                  SizedBox(
                    height: 16,
                  ),
                ]),
          );
        },
      ),
    );
  }
}
