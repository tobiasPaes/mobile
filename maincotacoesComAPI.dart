import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cotacoes/widgets/card_bolsa.dart';
import 'package:flutter_cotacoes/widgets/card_moeda.dart';
import 'package:flutter_cotacoes/widgets/card_moeda_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main card
            const CardMoeda(
              nomeMoeda: "Dollar",
              valorMoeda: "R\$ 4.9723",
              variacaoMoeda: "+0.000",
            ),
            const SizedBox(height: 20),
            const Text(
              'Outras moedas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const CardMoedaItem(
                    nomeMoeda: "EURO",
                    valorMoeda: "5.698",
                    variacaoMoeda: "0.000",
                  ),
                  const CardMoedaItem(
                    nomeMoeda: "Dollar",
                    valorMoeda: "4.985",
                    variacaoMoeda: "0.000",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bolsa de Valores',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BolsaValores(nomeInst: "IBOVESPA", localInst: "Sao Paulo, Brazil", instValor: "1.69",),

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
          'http://api.hgbrasil.com/finance/quotations?key=12ccfc63',
        ),
      );

      if (res.statusCode != HttpStatus.ok) {
        throw 'Erro de conexão';
      }

      final data = jsonDecode(res.body);

      // print(data);

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
            final dollar = data['results']['currencies']['USD'];
            final lista = data['results']['currencies'].values.toList();
            final listaBolsas = data['results']['stocks'].values.toList();
            print(listaBolsas);


            lista.removeAt(0);
            lista.removeAt(0);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CardMoeda(
                    nomeMoeda: dollar['name'],
                    valorMoeda: "${dollar['buy']}", 
                    variacaoMoeda: "${dollar['variation']}"),
                  const SizedBox(height: 20),
                  const Text(
                    'Outras moedas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: lista.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index){
                        return CardMoedaItem(
                          nomeMoeda: lista[index]['name'], 
                          valorMoeda: "${lista[index]['buy']}", 
                          variacaoMoeda: "${lista[index]['variation']}"
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    'Bolsa de Valores',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listaBolsas.length,
                      itemBuilder: (context, index){
                        return BolsaValores(
                          nomeInst: listaBolsas[index]['name'], 
                          localInst: listaBolsas[index]['location'], 
                          instValor: "${listaBolsas[index]['points']}",
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

