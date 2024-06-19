import 'package:flutter/material.dart';
import 'package:museumapp/pages/konten.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPages extends StatefulWidget {
  const MainPages({Key? key}) : super(key: key);

  @override
  State<MainPages> createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isCameraOpen = false;
  bool isScanned = false;
  bool isLoading = false;
  String logoPens = '';
  String logoAplikasi = '';
  String logoPensPsdku = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response =
        await http.get(Uri.parse('https://bar.kerissumenep.com/api/setting'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: logoPens.isNotEmpty
                        ? Image.network(
                            'https://bar.kerissumenep.com/setting/$logoPens',
                            height: 38,
                            width: 36.3,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox(),
                  ),
                  Expanded(
                    child: logoAplikasi.isNotEmpty
                        ? Image.network(
                            'https://bar.kerissumenep.com/setting/$logoAplikasi',
                            height: 95,
                            width: 95,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox(),
                  ),
                  Expanded(
                    child: logoPensPsdku.isNotEmpty
                        ? Image.network(
                            'https://bar.kerissumenep.com/setting/$logoPensPsdku',
                            height: 38,
                            width: 42.42,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
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
                                controller?.pauseCamera();
                                isCameraOpen = false;
                                isScanned = false;
                              } else {
                                controller?.resumeCamera();
                                isCameraOpen = true;
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                isCameraOpen
                                    ? Colors.red
                                    : const Color(0xFF58B431)),
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
                                  fontSize: 18,
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
                                    fontSize: 18,
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
                    child: const Center(
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
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {
        setState(() {
          isScanned = true;
          isLoading = true;
          controller.pauseCamera();
        });
        _launchURL(scanData.code);
      }
    });
  }

  void _launchURL(String? qrCode) async {
    if (qrCode != null) {
      final url = 'https://bar.kerissumenep.com/api/benda/$qrCode';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KontenPages(
              url: url,
              kode: qrCode,
            ),
          ),
        ).then((_) {
          setState(() {
            isLoading = false;
            isScanned = false;
            controller?.resumeCamera();
          });
        });
      } else {
        _showInvalidQRAlert();
        setState(() {
          isLoading = false;
          isScanned = false;
          controller?.resumeCamera();
        });
      }
    } else {
      _showInvalidQRAlert();
      setState(() {
        isLoading = false;
        isScanned = false;
        controller?.resumeCamera();
      });
    }
  }

  void _showInvalidQRAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Tidak Valid'),
          content: const Text('QR Code salah atau bukan punya kami.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
