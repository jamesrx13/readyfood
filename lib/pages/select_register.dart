import 'package:flutter/material.dart';
import 'package:ready_food/widgets/widgets.dart';

class SelectRegisterPage extends StatefulWidget {
  const SelectRegisterPage({Key? key}) : super(key: key);

  @override
  State<SelectRegisterPage> createState() => _SelectRegisterPageState();
}

class _SelectRegisterPageState extends State<SelectRegisterPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 270),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        '¿Empezar cómo?',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'restaurant', (route) => false);
                          },
                          child:
                              _tarjet('Restaurante', 'lib/img/restaurant.png'),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'trabajador', (route) => false);
                          },
                          child: _tarjet('Trabajador', 'lib/img/mesero.png'),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back_ios),
        backgroundColor: const Color.fromRGBO(63, 63, 156, 1),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _tarjet(String text, String urlPath) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _createCardShape(),
      child: (width > 320)
          ? Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Image.asset(
                  urlPath,
                  height: 170,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Image.asset(
                  urlPath,
                  height: 170,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          )
        ],
      );
}
