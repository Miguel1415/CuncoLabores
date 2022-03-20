import 'dart:io';
import 'package:cuncojobservice/inside.dart';
import 'package:cuncojobservice/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; //formateo hora


File image;
String filename;

class MyUpdatePage extends StatefulWidget {
  final DocumentSnapshot ds;
  MyUpdatePage({this.ds});
  @override
  _MyUpdatePageState createState() => _MyUpdatePageState();
}

class _MyUpdatePageState extends State<MyUpdatePage> {
  String productImage;
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  TextEditingController adressInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController webInputController;
  TextEditingController imageInputController;
  TextEditingController communeInputController;
  TextEditingController actividadInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;
  String adress;
  String phone;
  String email;
  String web;
  String commune;
  String actividad;

  pickerCam() async {
      // ignore: deprecated_member_use
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    // ignore: deprecated_member_use
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }
String selectedSalutation;
  @override
  void initState() {
    super.initState();
    recipeInputController =
        new TextEditingController(text: widget.ds.data["recipe"]);
    nameInputController =
        new TextEditingController(text: widget.ds.data["name"]);
    adressInputController =
        new TextEditingController(text: widget.ds.data["adress"]);
    phoneInputController =
        new TextEditingController(text: widget.ds.data["phone"]);
    emailInputController =
        new TextEditingController(text: widget.ds.data["email"]);
    actividadInputController =
        new TextEditingController(text: widget.ds.data["actividad"]);

    productImage = widget.ds.data["image"]; //nuevo
    print(productImage); //nuevo
  }

  /*
  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('colrecipes')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      // print(e);
    });
  }
  */

  Future getPosts() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("collection").getDocuments();
    // print();
    return qn.documents;
  }

  void updateData() async 
  {
    if (!_formKey.currentState.validate()) 
    {
      return;
    }
    _formKey.currentState.save();
    DateTime now = DateTime.now();
    String nuevoformato = DateFormat('kk:mm:ss:MMMMd').format(now);
    var fullImageName = 'nomfoto-$nuevoformato' + '.jpg';
    var fullImageName2 = 'nomfoto-$nuevoformato' + '.jpg';

    final StorageReference ref = FirebaseStorage.instance.ref().child(fullImageName);
    final StorageUploadTask task = ref.putFile(image);

    var part1 =
        //'https://firebasestorage.googleapis.com/v0/b/login-17ada.appspot.com/o/';
          'https://firebasestorage.googleapis.com/v0/b/labores-b91a4.appspot.com/o/';
        


     var fullPathImage = part1 + fullImageName2;
     print(fullPathImage);
     Firestore.instance
        .collection('collection')
        .document(widget.ds.documentID)
        .updateData({
      'name': nameInputController.text,
      'adress': adressInputController.text,
      'phone': phoneInputController.text,
      'email': emailInputController.text,
     // 'web': webInputController.text,
      'recipe': recipeInputController.text,
      //'comuna': selectedType, //edita el dato del nuevo dropdowm "comuna"
      'actividad': selectedAct, //edita el dato del nuevo dropdowm "actividad"
      'image': '$fullPathImage'
    });
    
  //Navigator.push(context,MaterialPageRoute(builder: (context) => PaginaMenu()));

  Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));

    // Navigator.of(context).pop(); //regrese a la pantalla anterior
    
  }

  /*final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  var selectedCurrency, selectedType;
  List<String> _accountType = <String>[
    'Cunco',
    'Melipeuco',  
    'Vilcun',
    'Curacautín',
    'Lonquimay'
  ];*/
  
  var selectedCurrencye, selectedAct;
  List<String> _selectedAct = <String>[
   'Limpieza de cañones',
    'Cortes de pasto',
    'Corte de leña',
    'Costuras',
    'Repostería',
    'Fontanería',
    'Carpintería',
    'Ojalatería',
  ];

  @override
  Widget build(BuildContext context) {

     String validateMobile(String value) {
//limitado a 9 dígitos   
 if (value.length != 9)
      return 'El número ingresado tiene menos de 9 dígitos';
    else
      return null;
  }
String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email no válido';
    else
      return null;
  }
  String validateName(String value) {
    if (value.length < 3)
      return 'El nombre debe tener mas de 2 caracteres';
    else
      return null;
  }
  /*
  String validateWeb(String value) {
  var urlPattern = r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
var match = new RegExp(urlPattern, caseSensitive: false).firstMatch('https://www.google.com');
match = RegExp(urlPattern, caseSensitive: false).firstMatch('http://www.google.com');
    RegExp regex = new RegExp(urlPattern);
    if (!regex.hasMatch(value))
      return 'Página Web no válida';
    else
      return null;
  }
  */
    getPosts();
    return Scaffold(
      appBar: AppBar(
       title: Text('Actualizar Datos'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      
                      
                      height: 100.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.blueAccent),
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null
                          ? Text('Reemplazar Imagen')
                          : Image.file(image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.blueAccent)),
                        padding: new EdgeInsets.all(5.0),
                        child: productImage == ''
                            ? Text('Edit')
                            : Image.network(productImage + '?alt=media'),
                      ),
                    ),
                    Divider(),
                    new FloatingActionButton(
                        heroTag: "aa", //boton para agregar los datos camara
                        backgroundColor: Color(0xff00aced),
                        child: Icon(Icons.camera_alt),
                        onPressed: pickerCam),
                    Divider(),
                    new FloatingActionButton(
                        //boton para agregar los datos galeria
                        heroTag:
                            "jj", //solucion a problema con botones, agrear el herotag:"btm1" y el new antes del FloatingActionButton
                        backgroundColor: Color(0xff00aced),
                        child: Icon(Icons.photo),
                        onPressed: pickerGallery),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    maxLength:27,
                    controller: nameInputController,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Nombre',
                      labelText: "Nombre",
                      fillColor: Color.fromRGBO(224, 224, 224, 1),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese un Nombre';
                      }
                    },
                    onSaved: (value) => name = value,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: adressInputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Dirección',
                      labelText: "Dirección",
                      fillColor: Color.fromRGBO(224, 224, 224, 1),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingrese una Dirección';
                      }
                    },
                    onSaved: (value) => adress = value,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                        maxLength: 9,//limita la cantidad de caracteres, en este caso números
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                      WhitelistingTextInputFormatter.digitsOnly
                      
                    ],
                    keyboardType: TextInputType.number,
                    controller: phoneInputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Teléfono',
                      labelText: "Teléfono",
                      fillColor: Color.fromRGBO(224, 224, 224, 1),
                      filled: true,
                    ),
                   validator: validateMobile,
                    onSaved: (value) => phone = value,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    
                    controller: emailInputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Email',
                      labelText: "Email",
                      fillColor: Color.fromRGBO(224, 224, 224, 1),
                      filled: true,
                    ),
                    validator: validateEmail,
                    onSaved: (value) => email = value,
                  ),
                ),
               
               /* Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: webInputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Página Web',
                      labelText: "Página Web",
                       fillColor: Color.fromRGBO(224, 224, 224, 1),
                      filled: true,
                    ),
                    validator: validateWeb,
                    onSaved: (value) => web = value,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 200, left: 10),
                  child: TextFormField(
                    enabled: false,
                    controller: communeInputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      // hintText: 'Comuna',

                      labelText: "Comuna Anterior",
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(23, 34, 43, 1),
                      ),
                      fillColor: Color.fromRGBO(255, 255, 255, 255),
                      filled: true,
                    ),
                  ),
                ),
                  DropdownButtonFormField<String>(
              value: selectedType,
              hint: Text(
                'Seleccione una Nueva Comuna',
              ),
           
              
              items: _accountType
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style:
                                  TextStyle(color: Color.fromRGBO(3, 9, 23, 1)),
                            ),
                            value: value,
                          ))
                      .toList(),
                       onChanged: (selectedAccountType) =>
                    setState(()=> selectedType = selectedAccountType),
                    validator: (value) => value == null ? 'Seleccione Comuna' : null,
                    
                  
            ),
            */
                
                
                Container(
                  margin: EdgeInsets.only(top: 20, right: 200, left: 10),
                  width: 200.0,
                  child: TextFormField(
                    enabled: false,
                    controller: actividadInputController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      // hintText: 'Comuna',
                      labelText: " Actividad Anterior",
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(23, 34, 43, 1),
                      ),
                      fillColor: Color.fromRGBO(255, 255, 255, 255),
                      filled: true,
                    ),
                  ),
                ),
               
                DropdownButtonFormField<String>(
              value: selectedAct,
              hint: Text(
                'Seleccione una Nueva Actividad',
              ),
           
                 items: _selectedAct
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style:
                                  TextStyle(color: Color.fromRGBO(3, 9, 23, 1)),
                            ),
                            value: value,
                          ))
                      .toList(),
                       onChanged: (selectedActivity) =>
                    setState(()=> selectedAct = selectedActivity),
                    validator: (value) => value == null ? 'Seleccione Actividad' : null,
                    
                  
            ),     
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: recipeInputController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Descripción',
                      labelText: "Descripción",
                      
                      fillColor: Color.fromRGBO(224, 224, 224, 1),
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                       return 'Ingrese una Descripción';
                      }
                    },
                    onSaved: (value) => recipe = value,
                  ),
                ),
              ],
            ),
          ),
        Container(
          margin: EdgeInsets.only(top: 15),//hace la separacion de el contenedor y el boton de "actualizar"
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new FloatingActionButton.extended(
                  //boton para agregar los datos

                  backgroundColor: Color(0xff00aced),
                  icon: Icon(Icons.save),
                  label: Text("Actualizar"),
                  onPressed: updateData),
            ],
          ),
        ],
      ),
    );
  }
}
