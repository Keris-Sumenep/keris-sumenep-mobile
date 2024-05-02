import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPages extends StatefulWidget {
  const MainPages({Key? key}) : super(key: key);

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isCameraOpen = false;
  bool isScanned = false;
  bool isLoading = false; // Tambahkan variabel isLoading

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'images/pens_remBG.png',
                          height: 38,
                          width: 36.3,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'images/pens_sumenep_bg.png',
                            height: 95,
                            width: 95,
                          ),
                          Image.asset(
                            'images/sumenep_logo-removebg.png',
                            height: 38,
                            width: 42.42,
                          ),
                        ],
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
        // Gunakan Stack untuk menempatkan widget popup di atas widget lainnya
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'images/Group.png',
                          width: 88.92,
                          height: 83.42,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Scan barcode di bawah',
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'Orelega One',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 4,
                              color: Color(0xFF1E1916),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: isCameraOpen ? null : const Color(0xFF2A3276),
                          border: Border.all(
                            color: const Color(0xFFFFF700),
                            width: 3,
                          ),
                        ),
                        child: isCameraOpen
                            ? QRView(
                                key: qrKey,
                                onQRViewCreated: _onQRViewCreated,
                              )
                            : const Center(
                                child: Text(
                                  'Klik tombol di bawah \n\tuntuk buka Kamera',
                                  style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        offset: Offset(3, 3),
                                        blurRadius: 4,
                                        color: Colors.black,
                                      ),
                                    ],
                                    fontSize: 16,
                                    fontFamily: 'Orelega One',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 95),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (isCameraOpen) {
                                isCameraOpen = false;
                                isScanned = false;
                              } else {
                                isCameraOpen = true;
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isCameraOpen
                                    ? Colors.red
                                    : const Color(0xFFFFF700)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            shadowColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 0, 0, 0)),
                            elevation: MaterialStateProperty.all<double>(9),
                          ),
                          child: Stack(
                            children: [
                              Text(
                                isCameraOpen ? 'Tutup Kamera' : 'Scan Sekarang',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Orelega One',
                                  color: isCameraOpen
                                      ? Colors.white
                                      : Colors.black,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(3, 3),
                                      blurRadius: 4,
                                      color: Color(0xFF1E1916),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Text(
                                  isCameraOpen
                                      ? 'Tutup Kamera'
                                      : 'Scan Sekarang',
                                  style: TextStyle(
                                    shadows: const [
                                      Shadow(
                                        offset: Offset(3, 2),
                                        blurRadius: 2.1,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                    fontSize: 25,
                                    fontFamily: 'Orelega One',
                                    color: isCameraOpen
                                        ? Colors.white
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        isScanned = true;
        isLoading = true;
      });
      _launchURL(scanData.code);
    });
  }

  void _launchURL(String? url) async {
    if (url != null) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Tidak Terdeksi $url';
      }

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
