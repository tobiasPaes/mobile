import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cotacoes/wigets/cardBolsa.dart';
import 'package:cotacoes/wigets/cardMoeda.dart';
import 'package:cotacoes/wigets/cardMoedaItem.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeMaterial(),
    );
  }
}

/*
class HomeMaterial extends StatelessWidget {
  const HomeMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cotações Brasil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main card
            CardMoeda(
                nomeMoeda: 'Euro',
                valorMoeda: 'R\$5,1',
                variacaoMoeda: '+10,00'),
            SizedBox(height: 20),
            Text(
              'Outras moedas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CardMoedaItem(
                    nomeMoeda: 'Dollar',
                    valorMoeda: 'R\$4.999',
                    variacaoMoeda: '+2,00',
                  ),
                  CardMoedaItem(
                    nomeMoeda: 'Dollar',
                    valorMoeda: 'R\$4.999',
                    variacaoMoeda: '+2,00',
                  ),
                  CardMoedaItem(
                    nomeMoeda: 'Dollar',
                    valorMoeda: 'R\$4.999',
                    variacaoMoeda: '+2,00',
                  ),
                  CardMoedaItem(
                    nomeMoeda: 'Dollar',
                    valorMoeda: 'R\$4.999',
                    variacaoMoeda: '+2,00',
                  ),
                  CardMoedaItem(
                    nomeMoeda: 'Dollar',
                    valorMoeda: 'R\$4.999',
                    variacaoMoeda: '+2,00',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Bolsa de Valores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardBolsa(
                  nomebolsa: 'IBOVESPA',
                  local: 'Sao Paulo, Brasil',
                  valor: '1.69',
                ),
                CardBolsa(
                  nomebolsa: 'IBOVESPA',
                  local: 'Sao Paulo, Brasil',
                  valor: '1.69',
                ),
                CardBolsa(
                  nomebolsa: 'IBOVESPA',
                  local: 'Sao Paulo, Brasil',
                  valor: '1.69',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/

class HomeMaterial extends StatefulWidget {
  const HomeMaterial({super.key});

  @override
  State<HomeMaterial> createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State<HomeMaterial> {
  late Future<Map<String, dynamic>> dadosCotacoes;

  @override
  void initState() {
    super.initState();
    dadosCotacoes = getDadosCotacoes();
  }

  Future<Map<String, dynamic>> getDadosCotacoes() async {
    print("get dados");
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.hgbrasil.com/finance/quotations?key=0d586d8a',
        ),
      );

      if (res.statusCode != HttpStatus.ok) {
        throw 'Erro de conexão';
      }

      final data = jsonDecode(res.body);

      print(data);

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cotações Brasil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
          future: dadosCotacoes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            final data = snapshot.data!;

            return Text("Dados lidos");
          }),
    );
  }
}
