import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mirror/services/shared_pref_services.dart';
import 'package:mirror/widget/wave.dart';

class MyMomentsScreen extends StatefulWidget {
  @override
  _MyMomentsScreenState createState() => _MyMomentsScreenState();
}

class _MyMomentsScreenState extends State<MyMomentsScreen>
    with SingleTickerProviderStateMixin {
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
                    'My Moments',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _playlist.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _playlist.length,
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
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 85,
                                      child: Stack(
                                        alignment: Alignment(0, 0),
                                        children: [
                                          SizedBox(
                                              height: 80,
                                              child: Image(
                                                image: AssetImage(
                                                  'assets/satsunglogo.png',
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                          Center(
                                            child: SizedBox(
                                              height: 85,
                                              child: IconButton(
                                                icon: playingIndex == index
                                                    ? Icon(
                                                        Icons.pause,
                                                        color: Colors.white,
                                                      )
                                                    : Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.white,
                                                      ),
                                                onPressed: () {
                                                  _isPlaying
                                                      ? _playPause()
                                                      : _playSelectedSong(
                                                          index);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _playlist[index]['name']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "poppins",
                                        color: Colors.white,
                                      ),
                                    ),
                                    playingIndex == index
                                        ? CustomPaint(
                                            painter: WavePainter(_controller),
                                            child:
                                                SizedBox(width: 24, height: 24),
                                          )
                                        : Icon(
                                            Icons.info_outline,
                                            color: Colors.white,
                                          ),
                                  ],
                                ),
                              ),
                              playingIndex == index
                                  ? StreamBuilder<Duration?>(
                                      stream: _durationStream,
                                      builder: (context, snapshot) {
                                        final duration =
                                            snapshot.data ?? Duration.zero;
                                        return StreamBuilder<Duration>(
                                          stream: _positionStream,
                                          builder: (context, snapshot) {
                                            final position =
                                                snapshot.data ?? Duration.zero;
                                            return Container(
                                              // margin: EdgeInsets.only(
                                              //     left: 4, right: 4),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "poppins",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Slider(
                                                      min: 0,
                                                      max: duration.inSeconds
                                                          .toDouble(),
                                                      value: position.inSeconds
                                                          .toDouble(),
                                                      onChanged: (value) =>
                                                          _audioPlayer.seek(
                                                              Duration(
                                                                  seconds: value
                                                                      .toInt())),
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: "poppins",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : Container()
                            ],
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
