import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class KontenPages extends StatefulWidget {
  final String url;
  final String kode;

  const KontenPages({Key? key, required this.url, required this.kode})
      : super(key: key);

  @override
  State<KontenPages> createState() => _KontenPagesState();
}

class _KontenPagesState extends State<KontenPages> {
  Map<String, dynamic>? kontenData;
  List<Map<String, dynamic>> languages = [];
  String selectedLanguage = 'Indonesia';
  final player = AudioPlayer();
  bool isPlaying = false;
  bool isDraggingSlider = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  PageController _pageController = PageController();
  String logoPens = '';
  String logoAplikasi = '';
  String logoPensPsdku = '';
  bool isLoading = false;

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
        final data = jsonDecode(response.body)['payload'];
        setState(() {
          kontenData = data;
          languages = (data['voice_bendas'] as List).map((voice) {
            return {
              'languageId': voice['languageId'],
              'bahasa': voice['language']['bahasa'],
            };
          }).toList();
          selectedLanguage = languages.first['bahasa'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error accordingly
    }

    final response2 =
        await http.get(Uri.parse('https://bar.kerissumenep.com/api/setting'));

    if (response2.statusCode == 200) {
      final data = json.decode(response2.body);
      setState(() {
        logoPens = data['payload'][0]['logo_pens'];
        logoAplikasi = data['payload'][0]['logo_aplikasi'];
        logoPensPsdku = data['payload'][0]['logo_pens_psdku'];
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
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
    // Check if kontenData is null and show a loading indicator
    if (kontenData == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF11497C),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white, // Warna teks
                  fontSize: 18.0, // Ukuran font
                ),
              ),
            ],
          ),
        ),
      );
    }

    final gambarList = kontenData!['gambar_bendas'] ?? [];
    final selectedLanguageData = kontenData!['deskripsis']
        .firstWhere((desc) => desc['language']['bahasa'] == selectedLanguage);
    final selectedVoiceData = kontenData!['voice_bendas']
        .firstWhere((voice) => voice['language']['bahasa'] == selectedLanguage);

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
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  logoPens.isNotEmpty
                      ? Image.network(
                          'https://bar.kerissumenep.com/setting/$logoPens',
                          height: 40,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        )
                      : SizedBox(),
                  logoAplikasi.isNotEmpty
                      ? Image.network(
                          'https://bar.kerissumenep.com/setting/$logoAplikasi',
                          height: 50,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        )
                      : SizedBox(),
                  logoPensPsdku.isNotEmpty
                      ? Image.network(
                          'https://bar.kerissumenep.com/setting/$logoPensPsdku',
                          height: 90,
                          width: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        )
                      : SizedBox(),
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
                                      kontenData!['nama'] ?? '',
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
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: gambarList.isNotEmpty
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 330,
                                                child: PageView.builder(
                                                  controller: _pageController,
                                                  itemCount: gambarList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final gambar =
                                                        gambarList[index];
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Image.network(
                                                        'https://bar.kerissumenep.com/foto-benda/${gambar['gambar']}',
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              SmoothPageIndicator(
                                                controller: _pageController,
                                                count: gambarList.length,
                                                effect: const WormEffect(
                                                  dotHeight: 12,
                                                  dotWidth: 12,
                                                  activeDotColor: Colors.white,
                                                  dotColor: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Text(
                                            'No image available',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
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
                        items: languages.map<DropdownMenuItem<String>>((lang) {
                          return DropdownMenuItem<String>(
                            value: lang['bahasa'],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                lang['bahasa'],
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
                            selectedLanguageData['deskripsi'] ?? '',
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
                                    playAudioFromUrl(
                                        'https://bar.kerissumenep.com/voice-benda/${selectedVoiceData['voice']}');
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
