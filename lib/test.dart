import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VoiceRecorderScreen extends StatefulWidget {
  const VoiceRecorderScreen({super.key});

  @override
  State<VoiceRecorderScreen> createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _recorder = AudioRecorder();
  String? _filePath;
  bool isRecording = false;
  Duration recordingDuration = Duration.zero;
  Timer? _timer;
  List<Map<String, dynamic>> recordings = [];
  int? currentlyPlayingIndex;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        currentlyPlayingIndex = null;
      });
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (hasPermission) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      setState(() {
        isRecording = true;
        recordingDuration = Duration.zero;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          recordingDuration =
              Duration(seconds: recordingDuration.inSeconds + 1);
        });
      });
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    _timer?.cancel();

    setState(() {
      isRecording = false;
      _filePath = path;

      if (path != null) {
        recordings.add({
          'path': path,
          'timestamp': DateTime.now(),
        });
      }
    });
  }

  Future<void> _togglePlayback(String path, int index) async {
    if (currentlyPlayingIndex == index) {
      await _audioPlayer.pause();
      setState(() {
        currentlyPlayingIndex = null;
      });
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(path));
      setState(() {
        currentlyPlayingIndex = index;
      });
    }
  }

  void _deleteRecording(int index) {
    File(recordings[index]['path']).deleteSync();
    setState(() {
      if (currentlyPlayingIndex == index) {
        _audioPlayer.stop();
        currentlyPlayingIndex = null;
      }
      recordings.removeAt(index);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Voice Recorder",
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onLongPress: _startRecording,
              onLongPressUp: _stopRecording,
              child: SizedBox(
                height: 50,
                width: 50,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? Colors.green : Colors.green,
                    boxShadow: isRecording
                        ? [BoxShadow(color: Colors.green, blurRadius: 10)]
                        : [],
                  ),
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Center(
                      child:
                          const Icon(Icons.mic, color: Colors.white, size: 30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isRecording)
              Text(
                "Recording: ${recordingDuration.inSeconds} sec",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            const SizedBox(height: 30),
            const Divider(),
            const Text(
              'List of Recordings',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: recordings.isEmpty
                  ? const Center(
                      child: Text(
                      "No recordings yet",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ))
                  : ListView.builder(
                      itemCount: recordings.length,
                      itemBuilder: (context, index) {
                        final rec = recordings[index];
                        final isPlaying = currentlyPlayingIndex == index;

                        return Card(
                          color: Colors.grey.shade200,
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () =>
                                  _togglePlayback(rec['path'], index),
                            ),
                            title: Text("Recording ${index + 1}"),
                            subtitle:
                                Text(rec['timestamp'].toString().split('.')[0]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteRecording(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
