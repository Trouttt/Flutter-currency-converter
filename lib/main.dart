import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=a6a93f0c";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white)));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar = 0.0;
  double euro = 0.0;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    dolarController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            //contem um mapa, pois o servidor da api vai retornar um mapa
            future: getData(),
            //especifica o local onde irá acontecer a requisição
            builder: (context, snapshot) {
              //snapshot é uma cópia dos dados obtidos
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState
                    .waiting: //se tiver carregando, irá entrar aqui
                  return Center(
                      child: Text("Carregando dados!",
                          style: TextStyle(color: Colors.amber, fontSize: 25.0),
                          textAlign: TextAlign.center));
                default: //caso não esteja carregando, ele irá vir pra cá
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar dados :)",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data!["results"]["currencies"]["USD"]["buy"];
                    euro =
                        snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Icon(Icons.monetization_on,
                                  size: 150.0, color: Colors.amber),
                              buildTextField(
                                  "Reais", "R\$", realController, _realChanged),
                              Divider(),
                              buildTextField("Dólares", "US\$", dolarController,
                                  _dolarChanged),
                              Divider(),
                              buildTextField(
                                  "Euros", "€", euroController, _euroChanged),
                            ]));
                  }
              }
            }));
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, f) {
  return TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 0.0),
          ),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      onChanged: f,
      keyboardType: TextInputType.number);
}
//print(json.decode(response.body)["results"]["currencies"]["USD"]);
//print(await getData()); pra chamar a funço
