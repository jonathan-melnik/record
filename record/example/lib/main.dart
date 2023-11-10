import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:record_example/audio_recorder.dart';
import 'package:record_example/upload_audio.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showPlayer = false;
  String? audioPath;
  List<String> transcriptions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Recorder(
                onStop: (path) {
                  if (kDebugMode) print('Recorded file path: $path');
                  setState(() {
                    audioPath = path;
                  });
                },
                onTranscribeComplete: (text) {
                  if (kDebugMode) print('Transcribed text: $text');
                  setState(() {
                    transcriptions.add(text);
                  });
                },
              ),
              Expanded(
                child: transcriptions.isNotEmpty
                    ? ListView.builder(
                        itemCount: transcriptions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(transcriptions[index]),
                          );
                        },
                      )
                    : const Center(
                        // Display a message when the list is empty
                        child: Text('No transcriptions available.'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
