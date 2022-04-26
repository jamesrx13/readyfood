import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/worker_model.dart';
import 'package:ready_food/utils/all_toast.dart';
import 'package:ready_food/utils/golbal_utils.dart';
import 'package:ready_food/widgets/auth_background.dart';
import 'package:ready_food/widgets/card_container.dart';

class MyProfileWorker extends StatefulWidget {
  final WorkerModel worker;
  const MyProfileWorker({Key? key, required this.worker}) : super(key: key);

  @override
  State<MyProfileWorker> createState() => _MyProfileWorkerState();
}

class _MyProfileWorkerState extends State<MyProfileWorker> {
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
      body: AuthBackground(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.2,
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.worker.imageUrl == 'lib/img/user.png'
                        ? AllToast.showInfoToast(context, 'No hay iamgen', '')
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              widget.worker.email,
                              style: const TextStyle(
                                fontSize: 15.0,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              widget.worker.phone,
                              style: const TextStyle(
                                fontSize: 15.0,
                                // fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
    );
  }
}
