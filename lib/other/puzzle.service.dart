import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game/other/puzzle_tile.model.dart';
import 'package:image/image.dart' as imglib;

class PuzzleService {
  static PuzzleService? _instance;
  static PuzzleService get instance => _instance ??= PuzzleService._();

  PuzzleService._();

  Future<List<PuzzleTile>> splitImage(String path, int gridSize) async {
    imglib.Image? image = await decodeAsset(path);

    List<PuzzleTile> pieces = [];
    int x = 0, y = 0;
    int width = (image!.width / gridSize).floor();
    int height = (image.height / gridSize).floor();
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        imglib.Image croppedImage =
            imglib.copyCrop(image, x: x, y: y, width: width, height: height);

        pieces.add(
          PuzzleTile(
            value: pieces.length + 1,
            image: Image.memory(
              imglib.encodeJpg(croppedImage),
              fit: BoxFit.fill,
            ),
            whiteSpace: i == gridSize - 1 && j == gridSize - 1,
          ),
        );
        x += width;
      }
      x = 0;
      y += height;
    }
    return pieces;
  }

  isAsset(String path) {
    final splits = path.split('/');

    if (splits.first == 'assets') {
      return true;
    }
    return false;
  }

  Future<imglib.Image?> decodeAsset(String path) async {
    Uint8List? data;
    if (isAsset(path)) {
      final byteData = await rootBundle.load(path);
      data = byteData.buffer.asUint8List();
    } else {
      data = await FirebaseStorage.instance.refFromURL(path).getData();
    }

    ImmutableBuffer? buffer = await ImmutableBuffer.fromUint8List(data!);
    final id = await ImageDescriptor.encoded(buffer);
    final codec = await id.instantiateCodec(
        targetHeight: id.height, targetWidth: id.width);

    final fi = await codec.getNextFrame();

    final uiImage = fi.image;
    final uiBytes = await uiImage.toByteData();

    final image = imglib.Image.fromBytes(
        width: id.width,
        height: id.height,
        bytes: uiBytes!.buffer,
        numChannels: 4);

    return image;
  }
}
