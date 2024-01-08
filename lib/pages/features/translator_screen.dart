import 'dart:io';
import 'package:ai_chat_bot/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  late AudioRecorder recorder;
  late Directory path;
  late String time;
  @override
  Future<void> initState() async {
    recorder = AudioRecorder();

    time = DateTime.now().microsecondsSinceEpoch.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    if (await recorder.hasPermission()) {
                      path = await getTemporaryDirectory();
                      await recorder.start(const RecordConfig(),
                          path: '${path.path}/$time.m4a');

                      final stream = await recorder.startStream(
                          const RecordConfig(encoder: AudioEncoder.pcm16bits));
                    }
                  },
                  child: const Text('record'))),
          ElevatedButton(
            onPressed: () async {
              await recorder.stop();
              APIs.sendAudio('${path.path}/$time.m4a');
            },
            child: const Text('pause'),
          )
        ],
      ),
    );
  }
}
