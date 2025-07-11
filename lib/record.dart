import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mirror/sidemenu/custom_appbar.dart';

class RecordThroughScreen extends StatefulWidget {
  const RecordThroughScreen({super.key});

  @override
  State<RecordThroughScreen> createState() => _RecordThroughScreenState();
}

class _RecordThroughScreenState extends State<RecordThroughScreen> {
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff345998),
      appBar: const CustomAppbar(title: 'Capture The Moment'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/bg_one.jpeg"), // Replace with your image path
            fit: BoxFit.cover, // Adjust as needed
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                textAlignVertical: TextAlignVertical.center,
                // controller: _controller,
                decoration: InputDecoration(
                  hintText: "Title the moment",
                  labelText: "Title the moment",
                  labelStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                  // prefixIcon: const Padding(
                  //   padding: EdgeInsets.fromLTRB(12, 12, 10, 15),
                  //   child:
                  //       Icon(Icons.title_outlined, size: 22, color: Colors.white),
                  // ),
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 10, 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xff4e77ba))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xff4e77ba))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xff4e77ba))),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xff4e77ba))),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onLongPress: _startRecording,
                    onLongPressUp: _stopRecording,
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff143061),
                          boxShadow: isRecording
                              ? [BoxShadow(color: Colors.green, blurRadius: 10)]
                              : [],
                        ),
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Center(
                            child: const Icon(Icons.mic,
                                color: Colors.white, size: 40)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
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
                          color: Color(0xff143061),
                          boxShadow: isRecording
                              ? [BoxShadow(color: Colors.green, blurRadius: 10)]
                              : [],
                        ),
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Center(
                            child: const Icon(Icons.pause,
                                color: Colors.white, size: 20)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isRecording)
                Text(
                  "Recording: ${recordingDuration.inSeconds} sec",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              const SizedBox(height: 30),
              // const Divider(),
              // const Text(
              //   'List of Recordings',
              //   style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.w600,
              //       color: Colors.green),
              // ),
              const SizedBox(height: 10),
              recordings.isEmpty
                  ? Container()
                  : SizedBox(
                      height: 90,
                      child: Card(
                        color: Color(0xff143061),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              currentlyPlayingIndex != null
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () =>
                                _togglePlayback(recordings[0]['path'], 0),
                          ),
                          title: Text(
                            "Recording ${1}",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            recordings[0]['timestamp'].toString().split('.')[0],
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "poppins",
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () => _deleteRecording(0),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logic for recording the thought
                    // Add your recording functionality here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                        'Thought recorded successfully!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: "poppins"),
                      )),
                    );
                  },
                  icon: Icon(Icons.mic),
                  label: Text(
                    'Submit',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: "poppins"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Note: Here the guidelines of How to capture the moment ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
