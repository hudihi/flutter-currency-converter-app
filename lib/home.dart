import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const request = 'https://api.hgbrasil.com/finance?format=json&key=60c6be1c58-3571420bc2-sbb60j';

class Home extends StatefulWidget {
  const Home({super.key,
  required this.title});
  final String title;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double dollarBuy;
  late double euroBuy;

  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final shillingController = TextEditingController();

  Future<Map> getData() async {
    var response = await http.get(Uri.parse(request));
    return json.decode(response.body);
  }

  void _clearAll(){
    dollarController.text = "";
    euroController.text = "";
    shillingController.text = "";
  }


  void _shill(){
    String text = shillingController.text;
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double shilling = double.parse(text);
    dollarController.text = (shilling / dollarBuy).toStringAsFixed(2);
    euroController.text = (shilling / euroBuy).toStringAsFixed(2);
  }

  void _dollar(){
    String text = shillingController.text;
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    dollarController.text = (dollar * dollarBuy).toStringAsFixed(2);
    euroController.text = (dollar * dollarBuy / euroBuy).toStringAsFixed(2);
  }

  void _euro(){
    String text = shillingController.text;
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    euroController.text = (euro * euroBuy).toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text('Loading...',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0
                  ),
                  textAlign: TextAlign.center,),
                );
              default:
                if(snapshot.hasError){
                  return const Center(
                    child: Text(
                      'Error :(',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                else{
                  dollarBuy = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                  euroBuy = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                  return Column(
                    children: <Widget>[
                      const Icon(Icons.monetization_on,
                      size: 250.0,
                      color: Colors.amber,
                      ),
                      buildTextField(
                        "Shilling",
                        "TSH",
                        shillingController,
                        _shill,
                      ),
                      const SizedBox(height: 50,),
                      buildTextField(
                        "Dollar",
                        "US\$",
                        dollarController,
                        _dollar,
                      ),
                      const SizedBox(height: 50.0,),
                      Expanded(
                        child: buildTextField(
                          "Euros",
                          "€",
                          euroController,
                          _euro,
                        ),
                      )
                    ],
                  );
                }
            }
          }
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      labelStyle: const TextStyle(
        color: Colors.amber,
        fontSize: 25.0,
      ),
      prefixText: prefix,
    ),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: f(),
  );
}