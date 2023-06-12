import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioMessage extends StatefulWidget {
  final String audioUrl;

  const AudioMessage({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_isPlaying) {
          await _audioPlayer.pause();
          setState(() {
            _isPlaying = false;
          });
        } else {
          await _audioPlayer.play(UrlSource(widget.audioUrl));
          setState(() {
            _isPlaying = true;
          });
        }
      },
      child: Container(
        width: 180,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
            Text(
              'Reproducir audio',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
