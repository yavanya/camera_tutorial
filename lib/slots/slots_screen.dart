import 'package:flutter/material.dart';

class SlotsScreen extends StatelessWidget {
  const SlotsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Слоты'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Card(
              elevation: 8,
            )
          ],
        ));
  }
}
