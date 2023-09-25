import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<img.Image> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFileFromAssets('asset/F.jpg').then(
      (value) {
        var image = img.decodeJpg(value.readAsBytesSync());
        list = splitImage(image!, 3, 3);
        list.shuffle();
      },
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  List<img.Image> splitImage(
      img.Image inputImage, int horizontalPieceCount, int verticalPieceCount) {
    img.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<img.Image>.empty(growable: true);

    for (var y = 0; y < image.height; y += pieceHeight) {
      for (var x = 0; x < image.width; x += pieceWidth) {
        pieceList.add(img.copyCrop(image,
            x: x, y: y, width: pieceWidth, height: pieceHeight));
      }
    }

    return pieceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Visibility(
        visible: false,
        child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: list.length,
            itemBuilder: (context, index) =>
                Container(child: Image.memory(img.encodeJpg(list[index]!)))),
        replacement: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5),
          itemCount: 9,
          itemBuilder: (context, index) => dr(index),
        ),
      ),
    );
  }
int d=-1;
List a=[1,2,3,4,5,6,7,8,9];
  Widget dr(int i) {
    return Center(
        child: Draggable(onDragCompleted: () {
          d=-1;
          setState(() {});
        },onDraggableCanceled: (velocity, offset) => setState(() {
          d=-1;
        }),data: i,onDragStarted: () => setState(() {
          d=i;
          print(i);
        }),
            feedback: Container(
              color: Colors.red,
              child: Center(child: Text('${a[i]}',style: TextStyle(fontSize: 32))),
              height: 150,
              width: 150,
            ),
            child: d!=-1 ? DragTarget(onAccept: (data) {
              data as int;
              var t=a[data];
              a[data]=a[i];
              a[i]=t;
            },builder: (context, candidateData, rejectedData) {
              return Container(
                color: d==i ? Colors.blue[(i+1)*100] : Colors.green,
                child: Center(child: Text('${a[i]}',style: TextStyle(fontSize: 32))),
                height: 150,
                width: 150,
              );
            },):
            Container(
              color: Colors.blue,
              child: Center(child: Text('${a[i]}',style: TextStyle(fontSize: 32))),
              height: 150,
              width: 150,
            )
        ));
  }
}
