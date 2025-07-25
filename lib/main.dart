import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_deck_ai/generated_slides.dart';
import 'package:flutter_deck_ws_client/flutter_deck_ws_client.dart';

const _presenterMode = bool.fromEnvironment('PRESENTER_MODE');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      slides: generatedSlides,
      client: FlutterDeckWsClient(
        uri: Uri.parse('ws://localhost:53837'),
      ),
      isPresenterView: _presenterMode,
    );
  }
}