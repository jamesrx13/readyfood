// ignore_for_file: unnecessary_this
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:ready_food/widgets/card_container.dart';

class MyQrCodePage extends StatefulWidget {
  const MyQrCodePage({Key? key, required this.restaurantName})
      : super(key: key);
  final String restaurantName;
  @override
  _MyQrCodePageState createState() => _MyQrCodePageState();
}

class _MyQrCodePageState extends State<MyQrCodePage> {
  Uint8List bytes = Uint8List(0);
  @override
  void initState() {
    _generateBarCode(currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black38,
          size: 35.0,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromRGBO(63, 63, 156, 1),
                Color.fromRGBO(90, 70, 178, 1),
              ]),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: CardContainer(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: SizedBox(
                      child: bytes.isEmpty
                          ? const Center(
                              child: Text('Empty code ... ',
                                  style: TextStyle(color: Colors.black38)),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.restaurantName,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Image.memory(
                                  bytes,
                                  height: 250,
                                  width: 250,
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                TextButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text('Guardar'),
                                      const Icon(Icons.download)
                                    ],
                                  ),
                                  onPressed: () async {
                                    final success =
                                        await ImageGallerySaver.saveImage(
                                            this.bytes);
                                    if (success.toString().isEmpty) {
                                      AllToast.showDangerousToast(context,
                                          'Oh, Oh...', 'Imagen NO guardada');
                                    } else {
                                      AllToast.showSuccessToast(
                                          context, 'Ok', 'QR guardado!');
                                    }
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await scanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }
}
