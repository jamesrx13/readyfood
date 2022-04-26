import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/worker_model.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/auth_background.dart';
import 'package:ready_food/widgets/card_container.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfilePage extends StatefulWidget {
  final WorkerModel worker;
  const MyProfilePage({Key? key, required this.worker}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Image.network(widget.worker.imageUrl).image;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: GLOBAL_COLOR,
        child: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          AuthBackground(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: GestureDetector(
                      onTap: () {
                        widget.worker.imageUrl == 'lib/img/user.png'
                            ? AllToast.showInfoToast(context, 'Sin imagen', '')
                            : showImageViewer(
                                context,
                                imageProvider,
                                onViewerDismissed: () {},
                                immersive: true,
                              );
                      },
                      child: Container(
                        height: 220,
                        width: 220,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                spreadRadius: 2.0,
                                blurRadius: 5.0,
                              )
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Hero(
                            tag: widget.worker.id,
                            child: widget.worker.imageUrl == 'lib/img/user.png'
                                ? Image.asset(
                                    'lib/img/user.png',
                                    fit: BoxFit.cover,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder: 'lib/img/loading.gif',
                                    image: widget.worker.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CardContainer(
                    child: Column(
                      children: [
                        Text(
                          widget.worker.name,
                          style: const TextStyle(
                            fontSize: 25.0,
                            // fontWeight: FontWeight.bold,
                            // color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () => _makeEmail(widget.worker.email),
                              child: Text(
                                widget.worker.email,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            const Icon(
                              Icons.phone,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () => _makePhoneCall(widget.worker.phone),
                              child: Text(
                                widget.worker.phone,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10.0,
            top: 50.0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(
                child: DropdownButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  isExpanded: true,
                  underline: Container(),
                  elevation: 24,
                  alignment: AlignmentDirectional.center,
                  borderRadius: BorderRadius.circular(15),
                  items: const [
                    DropdownMenuItem(
                      child: Text('Despedir'),
                      value: 'Despedir',
                    ),
                  ].toList(),
                  onChanged: (opt) {},
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _makeEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launch(launchUri.toString());
  }
}
