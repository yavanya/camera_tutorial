import 'package:camera_tutorial/gallery/gallery_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen(this.finalList, {Key? key})
      : super(
          key: key,
        );
  final finalList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GalleryViewModel>.reactive(
      viewModelBuilder: () => GalleryViewModel(finalList),
      builder: (context, model, child) {
        if (model.isBusy) {
          return Scaffold(
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
                    'Обработка изображений из потока',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            body: ListView(
              children: List.generate(
                model.finalImages.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: model.finalImages[index],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
