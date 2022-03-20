import 'dart:convert';
import 'package:cuncojobservice/inside.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cuncojobservice/viewpage.dart';
import 'package:intl/intl.dart'; //formateo hora

File image;
String filename;

void main() {
  runApp(MaterialApp(
    home: PaginaAdd(),
  ));
}

class PaginaAdd extends StatefulWidget {
  get fade => null;

  _PaginaAdd createState() => new _PaginaAdd();
}

class _PaginaAdd extends State<PaginaAdd> {
  @override
  Widget build(BuildContext contex) {
    return new MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Agregar Servicio',
      theme: new ThemeData(
        
        primarySwatch: Colors.red,
      ),
      home: new MyAddPage(),
    );
  }
}

class CommonThings {
  static Size size;
}

class MyAddPage extends StatefulWidget {
  @override
  _MyAddPageState createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  TextEditingController addressInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController imageInputController;
  TextEditingController selectedTypeInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;
  String adress;
  String phone;
  String email;
  String uidUser;

  pickerCam() async {
    var pickImage = ImagePicker.pickImage(source: ImageSource.camera);
    File img = await pickImage;
    if (img != null) 
    {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) 
    {
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

  void send() {
    Navigator.push(
      //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
      context,
      MaterialPageRoute(
          builder: (context) =>
              MyHomePage()), //envía a la siguenta pantalla en caso de ser logueado
    );
  }

  void home() {
    Navigator.push(
      //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
      context,
      MaterialPageRoute(
          builder: (context) =>
              PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
    );
  }

   

  void createData() async {
    
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();//se obtiene el UID del usuario actual.
    final uid = user.uid;
    print("UID del usuario actual: " + uid );//imprime el UID del usuario actual
  
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print(name);
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

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('collection').add({
        'name': '$name',
        'recipe': '$recipe',
        'adress': '$adress',
        'phone': '$phone',
        'email': '$email',
        'uid': '$uid',
        'actividad': '$selectedAct',
        'image': '$fullPathImage',
      });
      
      setState(() => id = ref.documentID);
      Navigator.push(
        //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
        context,
        MaterialPageRoute(
            builder: (context) =>
                (MyHomePage())), //envía a la siguenta pantalla en caso de ser logueado
      );
      //Navigator.of(context).pop(); //regrese a la pantalla anterior
    }
  }

   

  //final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
 /* var selectedCurrency, selectedType;
  List<String> _accountType = <String>[
    'Cunco',
    'Melipeuco',
    'Vilcun',
    'Curacautín',
    'Lonquimay'
  ];
  */
  
  var selectedCurrencye, selectedAct;// llena el conbobox de datos para desplegar
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
  Widget build(BuildContext context) 
  {
    
   
    CommonThings.size = MediaQuery.of(context).size;
    //validaciones de ingreso a los txts
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
      {
        return 'El nombre debe tener más de 2 caracteres';
      } 
      else
      {
        return null;
      }
        
        
    }

  /*String validateWeb(String value) {
      var urlPattern =
          r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
      var match = new RegExp(urlPattern, caseSensitive: false)
          .firstMatch('https://www.google.com');
      match = RegExp(urlPattern, caseSensitive: false)
          .firstMatch('http://www.google.com');
      RegExp regex = new RegExp(urlPattern);
      if (!regex.hasMatch(value))
        return 'Página Web no válida';
      else
        return null;
    }
*/

    return Scaffold(
      //backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      appBar: AppBar(
        title: Text('                      Lista Agregados'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                
                //Icons.arrow_right_alt_rounded,
                Icons.subdirectory_arrow_right_sharp,
                size: 45.0,
              ),
              onPressed: send),
        ],
      ),

      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, //genera espacio entre los dos botones
                  children: <Widget>[
                    new Container(
                      height: 240.0,
                      width: 240.0,
                      decoration: new BoxDecoration(
                        // color: const Color(0xff7c94b6),

                        border: new Border.all(
                          color: Color.fromRGBO(0, 3, 2, 1),//color de el marco de la fotografía
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: new EdgeInsets.all(1.0),
                      child: image == null
                      
                          ? Text('Cargar Imagen')
                          : Image.file(image),
                          
                          //validator:validateEmail,
                          ),
                    Divider(),
                    new FloatingActionButton(
                        heroTag: "aa", //boton para agregar los datos camara
                        backgroundColor: Color.fromARGB(220, 0, 172, 237),
                        child: Icon(Icons.camera_alt, size:35),//selecciona el icono y el tamaño del mismo
                        onPressed: pickerCam),//ejecuta accion al presionarl el bot
                    ///new IconButton(
                    // icon: new Icon(Icons.camera_alt), onPressed: pickerCam),//icono boton camara para ingreso de datos

                    new FloatingActionButton( 
                        //boton para agregar los datos galeria
                        heroTag:"jj", //solucion a problema con botones, agrear el herotag:"btm1" y el new antes del FloatingActionButton
                       // backgroundColor: Color(0xff00aced),//color en exadecimal
                        backgroundColor: Color.fromARGB(220, 0, 172, 237),//color en RBG                        child: Icon(Icons.photo),
                        child: Icon(Icons.photo, size: 35),
                        onPressed: pickerGallery),//abre la galeria de imagenes del dispositi
                    // new IconButton(
                    //   icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),               
                Container(                 
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                      maxLength:27,
                      decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),//designa el grado de curbatura del txt
                      hintText: 'Nombre',
                      labelText: 'Nombre',//muestra el nombre arriba del recuadro
                      fillColor: Colors.grey[300],//color del cuadro de texto
                      //fillColor:Color.fromRGBO(255, 255, 255, 0),
                      filled: true, //crea un recuadro donde se ingresa
                    ),
                    validator:
                        validateName, //valida el nombre, que sea sobre 2 caracteres
                    onSaved: (String value) 
                    {
                      name = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(

                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Dirección',
                      labelText: 'Dirección',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingrese dirección';
                      }
                    },
                    onSaved: (value) => adress = value,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    maxLength:
                        9, //limita la cantidad de caracteres, en este caso números
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(11),
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Teléfono',
                      labelText: 'Teléfono',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: validateMobile,
                    onSaved: (value) => phone = value,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Email',
                      labelText: 'Email',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: validateEmail,
                    onSaved: (value) => email = value,
                  ),
                ),
            
                /*DropdownButtonFormField<String>(
                  value: selectedType,
                  hint: Text(
                    'Seleccione una Comuna',
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
                      setState(() => selectedType = selectedAccountType),
                  validator: (value) =>
                      value == null ? 'Seleccione Comuna' : null,//validacion de el conbobox
                ),
                */
                SizedBox(height: 40.0),
                DropdownButtonFormField<String>(
                 
                  icon: Icon(Icons.arrow_drop_down_circle),//modifica el icono de el dropdown
                  iconDisabledColor: Colors.red,
                  iconEnabledColor:  Colors.blue,

                                  
                  isExpanded: true,
                  value: selectedAct,
                  hint: Text(
                    'Seleccione un Servicio',
                  ),
                  items: _selectedAct
                      .map((value) => DropdownMenuItem(
                            child: Text(
                              value,
                              style:
                                  //TextStyle(color:Colors.blueAccent, fontSize: 16),
                                  TextStyle(color: Color.fromRGBO(3, 9, 23, 1),fontSize: 20)    
                            ),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (selectedActivity) =>
                      setState(() => selectedAct = selectedActivity),
                  validator: (value) =>
                      value == null ? 'Seleccione Servicio' : null,//muestra mensaje si es que el campo está vacío
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextFormField(
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(18.0)),
                      hintText: 'Descripción del servicio',
                      labelText: 'Descripción',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Por favor ingrese descripción del servicio';
                      }
                    },
                    onSaved: (value) => recipe = value,
                  ),
                ),
                
              
                SizedBox(height: 40.0),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new FloatingActionButton.extended(
                  //boton para agregar los datos

                  backgroundColor: Color(0xff00aced),
                  icon: Icon(Icons.save),
                  label: Text("Agregar"),
                  onPressed: createData),
            ],
          ),
        ],
      ),
    );
    
  }
}