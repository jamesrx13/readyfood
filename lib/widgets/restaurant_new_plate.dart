// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/get_current_user_data_utils.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/utils/progress_dialog.dart';
import 'package:ready_food/widgets/osud_button.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: must_be_immutable
class RestaurantNewPlate extends StatefulWidget {
  PlateModel? plato;
  RestaurantNewPlate({Key? key, this.plato}) : super(key: key);

  @override
  State<RestaurantNewPlate> createState() => _RestaurantNewPlateState();
}

class _RestaurantNewPlateState extends State<RestaurantNewPlate> {
  var plateName = TextEditingController();
  var description = TextEditingController();
  var price = TextEditingController();
  String imageURL = '';
  bool uploadImg = false;
  var uuid = const Uuid().v1();
  XFile? _imagePicker;
  final ImagePicker _picker = ImagePicker();
  String title = 'Añadir un plato';
  String btnImagetext = '* Añadir imagen';
  String btnCtion = 'Guardar';

  void registerPlate(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const PogressDialig(
        status: 'Guardando...',
      ),
    );
    var conectivity = await Connectivity().checkConnectivity();
    if (conectivity != ConnectivityResult.wifi &&
        conectivity != ConnectivityResult.mobile) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', 'Sin conexión');
      return;
    }
    try {
      uploadFile(File(_imagePicker!.path)).then(
        (e) async {
          DatabaseReference newPlate = FirebaseDatabase.instance
              .ref()
              .child('restaurants/$currentUserId/plates/$uuid/');
          Map newPlateMap = {
            'plateName': plateName.text.trim(),
            'plateDescription': description.text.trim(),
            'platePrice': int.parse(price.text.trim()),
            'plateImageUrl': imageURL,
            'hasStock': true,
            'isSpecial': false,
          };
          await newPlate.set(newPlateMap);
          Navigator.pop(context);
          Navigator.pop(context);
          AllToast.showSuccessToast(context, 'Ok', 'Plato añadido');
        },
      );
    } catch (e) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', e.toString());
    }
  }

  void showPreviewImage() {
    if (_imagePicker != null) {
      setState(() {
        uploadImg = true;
      });
    }
    Navigator.of(context).pop();
  }

  Future<void> uploadFile(File img) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$currentUserId/plates/ReadyFood-$uuid.jpg')
          .putFile(img)
          .whenComplete(() async {
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('uploads/$currentUserId/plates/ReadyFood-$uuid.jpg')
            .getDownloadURL();
        setState(() {});
      });
    } on FirebaseException catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    if (widget.plato != null) {
      plateName.text = widget.plato!.name;
      description.text = widget.plato!.description;
      price.text = widget.plato!.price.toString();
      title = 'Editar un plato';
      btnImagetext = 'Actualiza la imagen';
      btnCtion = 'Actualizar';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Image.asset(
                'lib/img/logo.png',
                height: 200,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 40.0,
              ),
              _campoPlaceName(),
              const SizedBox(
                height: 30.0,
              ),
              _campoPlaceDescription(),
              const SizedBox(
                height: 30.0,
              ),
              _campoPlacePrive(),
              // const SizedBox(
              //   height: 10.0,
              // ),
              (uploadImg)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25.0)),
                            child: Image.file(
                              File(_imagePicker!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text(
                          'Imagen seleccionada',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 25.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _imagePicker = null;
                              uploadImg = false;
                            });
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Row(
                            children: [
                              Text(
                                btnImagetext,
                                style: const TextStyle(
                                  color: Colors.indigoAccent,
                                  fontSize: 16.0,
                                ),
                              ),
                              const Icon(
                                Icons.upload,
                                color: Colors.indigoAccent,
                                size: 25.0,
                              ),
                            ],
                          ),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (_) => _buildAlertDialog(),
                            );
                          },
                        ),
                      ],
                    ),
              const SizedBox(
                height: 30.0,
              ),
              OsudButton(
                content: btnCtion,
                color: GLOBAL_COLOR,
                onPressed: () {
                  if (plateName.text.length <= 3) {
                    AllToast.showInfoToast(
                        context, 'Oh, Oh...', 'Nombre no válido');

                    return;
                  }
                  if (description.text.length <= 3) {
                    AllToast.showInfoToast(
                        context, 'Oh, Oh...', 'Descripción no válido');
                    return;
                  }
                  if (price.text.length <= 2) {
                    AllToast.showInfoToast(
                        context, 'Oh, Oh...', 'Precio no válido');
                    return;
                  }
                  if (widget.plato != null) {
                    if (_imagePicker == null) {
                      _updateNoImage();
                    } else {
                      _updateHasImage();
                    }
                  } else {
                    if (_imagePicker == null) {
                      AllToast.showInfoToast(
                          context, 'Oh, Oh...', 'Falta la imagen');
                      return;
                    }
                    registerPlate(context);
                  }
                },
              ),
              const SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoPlaceName() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Nombre del plato',
      icon: const Icon(
        Icons.food_bank,
        size: 30.0,
      ),
      labelStyle: const TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      maxLength: 50,
      controller: plateName,
      keyboardType: TextInputType.text,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPlaceDescription() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Descripción',
      icon: const Icon(
        Icons.description,
        size: 30.0,
      ),
      labelStyle: const TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      maxLength: 300,
      controller: description,
      keyboardType: TextInputType.text,
      decoration: decoration,
      style: style,
    );
  }

  Widget _campoPlacePrive() {
    InputDecoration decoration = InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black38, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      labelText: 'Precio (Sin puntos o coma)',
      icon: const Icon(
        Icons.monetization_on_rounded,
        size: 30.0,
      ),
      labelStyle: const TextStyle(
        fontSize: 14.0,
      ),
      hintStyle: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
    const style = TextStyle(
      fontSize: 14.0,
    );
    return TextField(
      maxLength: 7,
      controller: price,
      keyboardType: TextInputType.number,
      decoration: decoration,
      style: style,
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      elevation: 100.0,
      title: const Text('Eliga una forma de selección'),
      content: SizedBox(
        height: 70,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 30.0,
                    color: Colors.indigoAccent,
                  ),
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      _imagePicker = image;
                      showPreviewImage();
                    });
                  },
                ),
                const Text('Cámara'),
              ],
            ),
            const SizedBox(
              width: 50.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.image,
                    size: 30.0,
                    color: Colors.indigoAccent,
                  ),
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _imagePicker = image;
                      showPreviewImage();
                    });
                  },
                ),
                const Text('Galeria'),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        TextButton(
          child: const Text("Aceptar"),
          onPressed: () async {},
        ),
      ],
    );
  }

  void _updateNoImage() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const PogressDialig(
        status: 'Actualizando...',
      ),
    );
    var conectivity = await Connectivity().checkConnectivity();
    if (conectivity != ConnectivityResult.wifi &&
        conectivity != ConnectivityResult.mobile) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', 'Sin conexión');
      return;
    }
    try {
      DatabaseReference newPlate = FirebaseDatabase.instance
          .ref()
          .child('restaurants/$currentUserId/plates/');
      Map updatePlateMap = {
        'plateName': plateName.text.trim(),
        'plateDescription': description.text.trim(),
        'plateImageUrl': widget.plato!.imageUrl.toString(),
        'platePrice': int.parse(price.text.trim()),
        'hasStock': widget.plato!.hasStock,
        'isSpecial': widget.plato!.isSpecial,
      };
      Map<String, Map> update = {};
      update[widget.plato!.id] = updatePlateMap;
      await newPlate.update(update);
      Navigator.pop(context);
      Navigator.pop(context);
      AllToast.showSuccessToast(context, 'Ok', 'Plato actualizado');
    } catch (e) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', e.toString());
    }
  }

  void _updateHasImage() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const PogressDialig(
        status: 'Actualizando...',
      ),
    );
    var conectivity = await Connectivity().checkConnectivity();
    if (conectivity != ConnectivityResult.wifi &&
        conectivity != ConnectivityResult.mobile) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', 'Sin conexión');
      return;
    }

    try {
      uploadFile(File(_imagePicker!.path)).then(
        (e) async {
          DatabaseReference newPlate = FirebaseDatabase.instance
              .ref()
              .child('restaurants/$currentUserId/plates/');
          Map updatePlateMap = {
            'plateName': plateName.text.trim(),
            'plateDescription': description.text.trim(),
            'platePrice': int.parse(price.text.trim()),
            'plateImageUrl': imageURL,
            'hasStock': widget.plato!.hasStock,
            'isSpecial': widget.plato!.isSpecial,
          };
          Map<String, Map> update = {};
          update[widget.plato!.id] = updatePlateMap;
          await newPlate.update(update);
          Navigator.pop(context);
          Navigator.pop(context);
          AllToast.showSuccessToast(context, 'Ok', 'Plato actualizado');
        },
      );
    } catch (e) {
      Navigator.pop(context);
      AllToast.showDangerousToast(context, 'Oh, Oh...', e.toString());
    }
  }
}
