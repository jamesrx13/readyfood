import 'package:flutter/material.dart';
import 'package:ready_food/widgets/history_pedidos_confirmados.dart';
import 'package:ready_food/widgets/history_pedidos_rechazados.dart';

class HistoriPage extends StatefulWidget {
  const HistoriPage({Key? key}) : super(key: key);

  @override
  State<HistoriPage> createState() => _HistoriPageState();
}

class _HistoriPageState extends State<HistoriPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Histórial',
            style: TextStyle(color: Colors.black54),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          foregroundColor: Colors.black54,
          bottom: const TabBar(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.black45,
            indicatorColor: Color.fromRGBO(63, 63, 156, 1),
            tabs: [
              Tab(text: 'Pedidos confirmados'),
              Tab(text: 'Pedidos rechazados'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            HistoryPedidosConfirmados(),
            HistoryPedidosRechazados(),
          ],
        ),
      ),
    );
  }
}
