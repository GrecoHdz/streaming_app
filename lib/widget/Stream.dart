import 'dart:async';
import 'package:flutter/material.dart';

class CounterStream {
  late StreamController<String> _streamController;
  int _cont = 0;
  CounterStream() {
    _streamController = StreamController<String>();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _cont++;
      _streamController.sink.add('Elemento $_cont');
    });
  }
  Stream<String> get stream => _streamController.stream;
  void dispose() {
    _streamController.close();
  }
}
class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);
  @override
  _CounterScreenState createState() => _CounterScreenState();
}
class _CounterScreenState extends State<CounterScreen> {
  late CounterStream _counterStream;
  List<String> _lista = [];
  @override
  void initState() {
    super.initState();
    _counterStream = CounterStream();
  }
  @override
  void dispose() {
    _counterStream.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Dinámica'),
        backgroundColor: const Color.fromARGB(255, 162, 250, 21),
      ),
      body: StreamBuilder<String>(
        stream: _counterStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar los datos'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }
          if (snapshot.data != null && !_lista.contains(snapshot.data!)) {
            _lista.add(snapshot.data!);
          }
          return ListView.builder(
            itemCount: _lista.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_lista[index]),
              );
            },
          );
        },
      ),
    );
  }
}
