import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Fonts/helveticaFont.dart';
import 'MusicModel.dart';
class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}
class _MusicScreenState extends State<MusicScreen> with TickerProviderStateMixin{
  final AudioPlayer _audioPlayer = AudioPlayer();
  late GifController controller2 = GifController(vsync: this,);
  bool _isPlaying = false;
  String _positionString = "0:00";
  String _durationString = "0:00";
  Duration _duration = const Duration();
  Duration _position = const Duration();
  String sname ="";
  @override
  void initState() {
    super.initState();
    controller2.repeat(
        period: const Duration(seconds: 1));
    _loadSong(songs[0].audioPath,songs[0].name);
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
        _durationString = _duration.inMinutes.remainder(60).toString().padLeft(2, '0') + ":" + (_duration.inSeconds.remainder(60)).toString().padLeft(2, '0');
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
        _positionString = _position.inMinutes.remainder(60).toString().padLeft(2, '0') + ":" + (_position.inSeconds.remainder(60)).toString().padLeft(2, '0');

      });
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }
  void _loadSong(String path ,String name) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    sname = name;
  }
  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      controller2.reset();
    } else {
      controller2.repeat(
          period: const Duration(
              seconds:
              1));
      _audioPlayer.resume();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffD3A3F1),
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back,size: 32,),
              onPressed: () {
                Navigator.of(context).pop();
                // Handle button press
              },
            ),
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(sname,style: GoogleFonts.inder(
            fontWeight: FontWeight.w600,
            color:  Colors.black,
            fontSize: 20
        ),),
      ),
            const Spacer(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            const SizedBox(
              height: 80,
            ),
            Gif(
              height: 300,
              width: 300,
              controller: controller2,
              fit: BoxFit.fill,
              image: const AssetImage(
                "assets/Songs/ms.gif",
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xffD3A3F1),
                    radius: 25,
                    child:  Helvetica(
                        text:_durationString,
                        color: Colors.black,
                        size: 15,
                        weight: FontWeight.w600
                    ),

                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xffD3A3F1),
                    radius: 25,
                    child: IconButton(
                      onPressed: _playPause,
                      icon: _isPlaying ? const Icon(Icons.pause,size: 30,) : const Icon(Icons.play_arrow,size: 30,),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: const Color(0xffD3A3F1),
                    radius: 25,
                    child:Helvetica(
                        text:_positionString,
                        color: Colors.black,
                        size: 15,
                        weight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
