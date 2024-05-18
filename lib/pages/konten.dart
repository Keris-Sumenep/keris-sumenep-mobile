import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:museumapp/pages/scan.dart';

class KontenPages extends StatefulWidget {
  final String url;
  final String kode;

  const KontenPages({Key? key, required this.url, required this.kode})
      : super(key: key);

  @override
  State<KontenPages> createState() => _KontenPagesState();
}

class _KontenPagesState extends State<KontenPages> {
  late Map<String, dynamic> kontenData = {};
  String selectedLanguage = 'Indonesia';
  final player = AudioPlayer();
  bool isPlaying = false;
  bool isDraggingSlider = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    fetchData();
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onPositionChanged.listen((position) {
      if (!isDraggingSlider) {
        setState(() {
          currentPosition = position;
        });
      }
    });

    player.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          kontenData = jsonDecode(response.body)['payload'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error accordingly
    }
  }

  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  Future<void> stopAudio() async {
    await player.stop();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [minutes, seconds].join(':');
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11497C),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 18, 16, 16).withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/pens_remBG.png',
                        height: 38,
                        width: 36.3,
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/pens_sumenep_bg.png',
                        height: 95,
                        width: 95,
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/sumenep_logo-removebg.png',
                        height: 38,
                        width: 42.42,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3276),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.yellow,
                          width: 1.0,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 290,
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 10,
                                        bottom: 2),
                                    child: Text(
                                      kontenData['nama'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Orelega One',
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Image.asset(
                                      'images/keris.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          'Pilih Bahasa:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: Color(0xFF2A3276),
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                        items: <String>['Indonesia', 'English', 'Madura']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            kontenData['deskripsi'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Slider(
                              value: currentPosition.inSeconds.toDouble(),
                              max: totalDuration.inSeconds.toDouble(),
                              onChanged: (double value) async {
                                setState(() {
                                  isDraggingSlider = true;
                                });
                                final position =
                                    Duration(seconds: value.toInt());
                                await player.seek(position);
                              },
                              onChangeEnd: (double value) {
                                setState(() {
                                  isDraggingSlider = false;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (isPlaying) {
                                    stopAudio();
                                  } else {
                                    playAudioFromUrl(widget.url);
                                  }
                                },
                                child: Text(
                                  isPlaying ? 'Stop Audio' : 'Putar Audio',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Orelega One',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isPlaying
                                      ? Colors.red
                                      : const Color(0xFF58B431),
                                  shadowColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
