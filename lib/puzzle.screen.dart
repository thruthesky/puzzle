import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/puzzle.board.dart';
import 'package:game/puzzle.state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';

class OtherPuzzleScreen extends StatelessWidget {
  const OtherPuzzleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer(builder: (context, ref, child) {
          bool isLoading = ref.watch(puzzleImagesProvider).isEmpty;
          return Column(
            children: [
              _displayImageFromUrls(context, ref),
              const SizedBox(height: 16),
              if (isLoading) ...[
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: PuzzleBoard(
                    crossAxisCount: ref.watch(gridSize),
                    puzzleTiles: ref.watch(puzzleImagesProvider),
                    numbered: ref.watch(isNumbered),
                    active: ref.watch(isActive),
                  ),
                ),
              ],
              Wrap(
                children: [
                  _changeSize('2x2', ref, size: 2),
                  _changeSize('3x3', ref, size: 3),
                  _changeSize('4x4', ref, size: 4),
                  _changeSize('5x5', ref, size: 5),
                  _changeSize('6x6', ref, size: 6),
                  _changeSize('7x7', ref, size: 7),
                  _changeSize('8x8', ref, size: 8),
                  _changeSize('9x9', ref, size: 9),
                ],
              ),
              _btn('Play', () {
                ref.read(puzzleImagesProvider.notifier).shuffle();
                playAudio();
              }),
              _btn('Upload Image', () async => await uploadPic(ref)),
            ],
          );
        }),
      ),
    );
  }

  Widget _displayImageFromUrls(BuildContext context, WidgetRef ref) {
    final uploadUrls = ref.watch(urls);
    final selectedIndex = ref.watch(selectedUrlIndex);
    return switch (uploadUrls) {
      AsyncError(:final error) => Text('Error: $error'),
      AsyncData(:final value) => SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: value.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  ref.read(selectedUrlIndex.notifier).state = selectedIndex;
                  ref.read(puzzleImagesProvider.notifier).setNewImage(
                        value[index],
                      );
                },
                child: CachedNetworkImage(
                  imageUrl: value[index],
                ),
              );
            },
          ),
        ),
      _ => const CircularProgressIndicator(),
    };
  }

  ElevatedButton _changeSize(String label, WidgetRef ref, {required int size}) {
    return ElevatedButton(
      onPressed: () {
        ref.read(gridSize.notifier).state = size;
      },
      child: Text(label),
    );
  }

  ElevatedButton _btn(
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

//Creating a global Variable
  uploadPic(WidgetRef ref) async {
    Reference reference = FirebaseStorage.instance.ref();

    //Get the file from the image picker and store it
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    final refPath = reference.child("images/${image!.path.split("/").last}");
    final file = File(
      image.path,
    );
    //Upload the file to firebase
    final uploadTask = refPath.putFile(file);
    await uploadTask.whenComplete(() {});

    // Waits till the file is uploaded then stores the download url
    final location = await refPath.getDownloadURL();

    ref.read(urls.future).then((state) => state.add(location));
  }

  playAudio() async {
    final player = AudioPlayer();
    await player.setAsset('assets/sound/play.start.mp3');

    await player.play();
  }
}
