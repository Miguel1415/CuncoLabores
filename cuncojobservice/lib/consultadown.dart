//funciona bien pero ahora necesitamos con una coleccion de array
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyQueryPage(),
    );
  }
}

class MyQueryPage extends StatefulWidget {
  @override
  _MyQueryPageState createState() => _MyQueryPageState();
}

class _MyQueryPageState extends State<MyQueryPage> {
  var selectedCurrency, selectedType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
          title: Text('DropDown'),
        ),
        body: new Form(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            children: <Widget>[
              
              SizedBox(
                height: 20.0,
              ),
              new StreamBuilder<QuerySnapshot>(
                  stream:
                      Firestore.instance.collection("colrecipes").snapshots(),//obtiene los datos de la base de datos
                  builder: (context, snapshot) {
                    return new DropdownButton(
                      items: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return DropdownMenuItem(
                            child: new Text(document.data["Activity"]));//obtiene la actividad desde la base de datos
                      }).toList(),
                      onChanged: (currencyValue) {
                        setState(() {
                          selectedCurrency = currencyValue;
                        });
                      },
                      hint: new Text("Join a Team"),
                      value: selectedCurrency,
                    );
                  }),
            ],
          ),
        ));
  }
}
