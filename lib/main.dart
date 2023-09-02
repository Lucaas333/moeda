import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//URL para API
const request = 'https://api.hgbrasil.com/finance?format=json-cors&key=6a17d833';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ),
  );
}

Future<Map> getData() async {
  //Fazer requisição
  //Decodificar o JSON
  http.Response resposta = await http.get(Uri.parse(request));
  return json.decode(resposta.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar = 0;
  double euro = 0;

  void _convertDolar(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _convertEuro(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _convertReal(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
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
        future: getData(),
        builder: (context, snapshot){
          //Verifica o estado de conexão com a API
          switch(snapshot.connectionState){
           case ConnectionState.none:
           case ConnectionState.waiting:
            return Center(
              child: Text(
                "Carregando informações",
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,
              )
            );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    "Erro ao carregar informações",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      TextField(
                        controller: realController,
                        style: TextStyle(
                          color:Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Reais",
                          labelStyle: TextStyle(
                          color:Colors.amber,
                          fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "R\$",
                        ),
                        onChanged: _convertReal,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        style: TextStyle(
                          color:Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Dolares",
                          labelStyle: TextStyle(
                          color:Colors.amber,
                          fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "\$",
                        ),
                        onChanged: _convertDolar,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        style: TextStyle(
                          color:Colors.amber,
                          fontSize: 25.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "Euro",
                          labelStyle: TextStyle(
                          color:Colors.amber,
                          fontSize: 20.0,
                          ),
                          border: OutlineInputBorder(),
                          prefixText: "€",
                        ),
                        onChanged: _convertEuro,
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
