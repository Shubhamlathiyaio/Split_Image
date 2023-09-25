import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

void main(List<String> args) {
  runApp(MaterialApp(home: Home(),));
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decode('asset/F.jpg');
    // splitImage();
  }

decode(String a)
{
  final image = img.decodeJpg(File('$a').readAsBytesSync());
  return image;
}

  List<img.Image> splitImage(img.Image inputImage, int horizontalPieceCount, int verticalPieceCount) {
    img.Image image = inputImage;

    final pieceWidth = (image.width / horizontalPieceCount).round();
    final pieceHeight = (image.height / verticalPieceCount).round();
    final pieceList = List<img.Image>.empty(growable: true);

    int h=0,w=0;
    for (var y = 0; y < image.height; h*= y,y++  ) {
      for (var x = 0; x < image.width; w*= x,x++) {
        pieceList.add(img.copyCrop(image, x: w, y: h, width: pieceWidth, height: pieceHeight));
      }
    }

    return pieceList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Image(image: AssetImage('asset/F.jpg'),fit: BoxFit.fill,)),
    );
  }
}