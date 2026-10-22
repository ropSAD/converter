import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'converter_screen.dart';
import 'converter_state.dart';
import 'currency_repository.dart';

void main() {
  ConverterState st = ConverterState(
    CurrencyRepository(ApiClient(http.Client())),
  );
  runApp(MyApp(st: st));
}

class MyApp extends StatelessWidget {
  final ConverterState st;
  const MyApp({super.key, required this.st});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Деньги',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ConverterScreen(st: st),
    );
  }
}
