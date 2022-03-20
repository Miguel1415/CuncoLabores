import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MyInfoPage extends StatefulWidget {
  final DocumentSnapshot ds;
  MyInfoPage({this.ds});
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String productImage;
  String id;
  String name;
  String address;
  String phone;
  String recipe;
  String email;
  String web;

  TextEditingController nameInputController;
  TextEditingController recipeInputController;
  TextEditingController adressInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController webInputController;
  TextEditingController actividadInputController;
  TextEditingController communeInputController;

  Future getPost() async 
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("collection").getDocuments();
    return qn.documents;
  }
  
  @override
  void initState() {
    super.initState();
    recipeInputController =
        new TextEditingController(text: widget.ds.data["recipe"]);//obtiene los datos de la db
    nameInputController =
        new TextEditingController(text: widget.ds.data["name"]);
    adressInputController =
        new TextEditingController(text: widget.ds.data["adress"]);
    phoneInputController =
        new TextEditingController(text: widget.ds.data["phone"]);
    emailInputController =
        new TextEditingController(text: widget.ds.data["email"]);
    //webInputController = new TextEditingController(text: widget.ds.data["web"]);
    actividadInputController =
        new TextEditingController(text: widget.ds.data["actividad"]);
    //communeInputController =
    //    new TextEditingController(text: widget.ds.data["comuna"]);
    productImage = widget.ds.data["image"];
    print(productImage);
  }

  _launchURL() async {
    String url = "tel:+56" + phoneInputController.text; //permite enviar el numero de teléfono para llamar agregandole el +56
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchURLWEB() async {// abre app de coreo
    String email = emailInputController.text;//obtiene el email de caja de texto

    if (await canLaunch("mailto:$email")) {//pasa el email para enviar correo
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }
  _canLaunch() async {
    String phone = "tel:+56" + phoneInputController.text;//agrego el +56 a cada numero que se agregue
      var whatsappUrl ="whatsapp://send?phone=$phone";//abre la aplicacion wsp 
      await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

  @override
  Widget build(BuildContext context) {
    getPost();
    return Scaffold(
      appBar: AppBar(
        title: Text('Descripción servicio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 320.0,
                      width: 320.0,
                      decoration: new BoxDecoration(
                        border: new Border.all(
                          color: Color.fromRGBO(0, 3, 2, 1),//color del box de fotografia 
                          width: 8,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //border: new Border.all(color: Colors.blueAccent)),
                      padding: new EdgeInsets.all(1.0),
                      child: productImage == ''
                          ? Text('Edit')
                          : Image.network(productImage + '?alt=media'),
                    ),
                  ],
                ),
                
                new IniciarIcon(),
                new FloatingActionButton.extended(
                    //boton para agregar los datos
                    backgroundColor: Color.fromARGB(200, 6, 121, 211),
                    icon: Icon(Icons.phone),
                    heroTag: "aas",
                    label: Text("  Llamar  "),
                    onPressed: _launchURL),//para llamar
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                new FloatingActionButton.extended(
                    //boton para agregar los datos

                    backgroundColor: Color.fromARGB(200, 90, 200, 211),
                    icon: Icon(Icons.email),
                    heroTag: "aasy",
                    label: Text("   Email    "),
                    onPressed: _launchURLWEB),//para enviar un correo
                     Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                    new FloatingActionButton.extended(
                    //boton para agregar los datos
                    backgroundColor: Color.fromARGB(200, 74, 211, 80),
                    icon: Icon(Icons.phone),
                    heroTag: "aasya",
                    label: Text("WhatsApp"),
                    onPressed: _canLaunch),//para mandar un wsp

                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: new TextFormField(
                    enabled: false,//bloquea el txt para ingreso de datos
                    controller: nameInputController,
                  
                    decoration: new InputDecoration(
                        hintText: "Nombre", labelText: "Nombre"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.place, color: Colors.red),
                  title: new TextFormField(
                    enabled: false, //no permite editar información
                    controller: adressInputController,
               
                    decoration: new InputDecoration(
                        enabled: false,
                        hintText: "Dirección",
                        labelText: "Dirección"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: new TextFormField(
                    enabled: false,
                    controller: phoneInputController,
                
                    decoration: new InputDecoration(
                        hintText: "Teléfono", labelText: "Teléfono"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: new TextFormField(
                    enabled: false,
                    maxLines: 1,
                    controller: emailInputController,
                    decoration: new InputDecoration(
                        hintText: "Email", labelText: "Email"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                /*
                new ListTile(
                  leading: const Icon(Icons.place, color: Colors.black),
                  title: new TextFormField(
                    enabled: false,
                    maxLines: 1,
                    controller: communeInputController,
                    decoration: new InputDecoration(
                        hintText: "Comuna", labelText: "Comuna"),
                  ),
                ),
                */
               /* new ListTile(
                  leading: const Icon(Icons.web, color: Colors.black),
                  title: new TextFormField(
                    enabled: false,
                    maxLines: 1,
                    controller: webInputController,
                    decoration: new InputDecoration(
                        hintText: "Página Web", labelText: "Página Web"),
                  ),
                ),
                */
                new ListTile(
                  leading: const Icon(Icons.work, color: Colors.black),
                  title: new TextFormField(
                    enabled: false,
                    maxLines: 1,
                    controller: actividadInputController,
                    
                    decoration: new InputDecoration(
                        hintText: "Actividad", labelText: "Actividad"),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.list, color: Colors.red),
                  title: new TextFormField(
                    enabled: false,
                    maxLines: 10,
                    controller: recipeInputController,
                 
                    decoration: new InputDecoration(
                        hintText: "Descripción", labelText: "Descripción"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IniciarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[],
      ),
    );
  }
}

class IconoMenu extends StatelessWidget {
  IconoMenu({this.icon, this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Text(
            label,
            style: new TextStyle(fontSize: 12.0, color: Colors.blue),
          )
        ],
      ),
    );
  }
}
