import 'package:camera_tutorial/back_live/back_live_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BackLiveScreen extends StatelessWidget {
  const BackLiveScreen(this.finalList, {Key? key})
      : super(
          key: key,
        );
  final finalList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BackLiveViewModel>.reactive(
      viewModelBuilder: () => BackLiveViewModel(finalList),
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
              body: Center(child: model.finalImage),
            ),
          );
        }
      },
    );
  }
}
