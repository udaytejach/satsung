import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class MotivationalMusicPage extends StatefulWidget {
  const MotivationalMusicPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MotivationalMusicPage> createState() => _MotivationalMusicPage();
}

class _MotivationalMusicPage extends State<MotivationalMusicPage>
    with TickerProviderStateMixin {
  final List<String> motivationalTracks = [
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
    "Track 1: Serenity",
    "Track 2: Deep Sleep",
    "Track 3: Calm Waves",
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Map<String, String>> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  int playingIndex = -1;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Continuous animation
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadAudioFiles() async {
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    var json;
    final Map<String, dynamic> manifestMap = json.decode(manifestJson);
    final audioFiles = manifestMap.keys
        .where(
            (String key) => key.startsWith('assets/') && key.endsWith('.mp3'))
        .toList();

    setState(() {
      _playlist = audioFiles
          .map((path) => {
                'path': path,
                'name': path
                    .split('/')
                    .last
                    .replaceAll('%20', ' ')
                    .replaceAll('_', ' ')
                    .replaceAll('.mp3', '')
              })
          .toList();
    });

    if (_playlist.isNotEmpty) {
      await _audioPlayer.setAsset(_playlist[_currentIndex]['path']!);
    }
  }

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      playingIndex = -1;
    } else {
      _audioPlayer.play();
      playingIndex = _currentIndex;
    }
  }

  void _nextSong() {
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    _audioPlayer.setAsset(_playlist[_currentIndex]['path']!);
    _audioPlayer.play();
  }

  void _previousSong() {
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    _audioPlayer.setAsset(_playlist[_currentIndex]['path']!);
    _audioPlayer.play();
  }

  void _playSelectedSong(int index) {
    _currentIndex = playingIndex = index;
    _audioPlayer.setAsset(_playlist[_currentIndex]['path']!);
    _audioPlayer.play();
  }

  Stream<Duration> get _positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get _durationStream => _audioPlayer.durationStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff345998),
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Motivational Music',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: motivationalTracks.length,
                itemBuilder: (context, index) {
                  return Card(
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xff4e77ba), // Set the border color
                        width: 2.0, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // color: Color(0xff143061),
                    color: Colors.transparent,
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                      title: Text(
                        motivationalTracks[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins",
                          color: Colors.white,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Add playback logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                              'Playing ${motivationalTracks[index]}',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins",
                                color: Colors.white,
                              ),
                            )),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Card design for player view
            // Card(
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //       side: const BorderSide(width: 0.7)),
            //   clipBehavior: Clip.antiAlias,
            //   child: Column(
            //     children: [
            //       SizedBox(height: 10),
            //       Text(
            //           _playlist.isNotEmpty
            //               ? 'Playing: ${_playlist[_currentIndex]['name']}'
            //               : 'No Songs Found',
            //           style: TextStyle(fontSize: 16)),
            //       StreamBuilder<Duration?>(
            //         stream: _durationStream,
            //         builder: (context, snapshot) {
            //           final duration = snapshot.data ?? Duration.zero;
            //           return StreamBuilder<Duration>(
            //             stream: _positionStream,
            //             builder: (context, snapshot) {
            //               final position = snapshot.data ?? Duration.zero;
            //               return Column(
            //                 children: [
            //                   Slider(
            //                     min: 0,
            //                     max: duration.inSeconds.toDouble(),
            //                     value: position.inSeconds.toDouble(),
            //                     onChanged: (value) => _audioPlayer
            //                         .seek(Duration(seconds: value.toInt())),
            //                   ),
            //                   Text(
            //                     '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
            //                   ),
            //                 ],
            //               );
            //             },
            //           );
            //         },
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           IconButton(
            //               icon: Icon(Icons.skip_previous),
            //               onPressed: _previousSong),
            //           IconButton(
            //               icon:
            //                   Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            //               onPressed: _playPause),
            //           IconButton(
            //               icon: Icon(Icons.skip_next), onPressed: _nextSong),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
