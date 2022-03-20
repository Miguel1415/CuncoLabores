import 'package:cuncojobservice/consultas.dart';
import 'package:cuncojobservice/informationpage.dart';
import 'package:cuncojobservice/inside.dart';
import 'package:cuncojobservice/updatepage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/text.dart';

import 'add.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Resultados',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyHomePage(),
    );
  }
}

class CommonThings {
  static Size size;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var queryResultSet = [];
  var tempResultSet = [];

  initiateFiltro(value) 
  {
    if(value.length==0)
    {
      setState(() 
      {
         queryResultSet=[];
         tempResultSet=[];
      });
    }
    if (queryResultSet.length == 0 && value.length == 1) 
    {
      colleccion(value).then((QuerySnapshot docs)
      {
        for(int i=0; i<docs.documents.length; i++)
        {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    }
    else
    {
      tempResultSet=[];
      queryResultSet.forEach((element) 
      {
         if(element['uid']==uid)
         {
           setState(() 
           {
             tempResultSet.add(element);
           });
         }
      });
    }
  }

  // List<Note> _notes=List<Note>();
  //List <Note> _notesForDisplay=List<Note>();
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  String id;
  final db = Firestore.instance;
  //final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;
  String filtro;
  String uid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  inputData() async {
    // funcion para obtener el UID del usuario actual
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    print("UID del usuario actual: " + uid); //imprime el UID del usuario actual
    return uid;
  }

  void idCurrentUser() {
    inputData();
  }

  //crea la funcion para eliminar un registro
  void deleteData(DocumentSnapshot doc) async {
    await db.collection('collection').document(doc.documentID).delete();
    setState(() => id = null);
    print("id del documento eliminado " + doc.documentID);
  }

  void showAlertDialog(DocumentSnapshot doc) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () => Navigator.pop(
          context), //al cancelar cierra el cuadro y se mantiene en la página
    );

    Widget continueButton = FlatButton(
        child: Text("Continuar"),
        onPressed: () {
          deleteData(
              doc); //al precionar aceptar llama la funcion de arriba en el cual elimina el documento con la información almacenada
          Navigator.pop(context); // y cierra la alerta en la pantalla
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aterta!!"),
      content: Text("Está seguro de eliminar esta publicación?"),
      actions: 
      [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //create tha funtion navigateToDetail
  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyUpdatePage(
                  ds: ds,
                )));
  }

  //create tha funtion navigateToDetail
  navigateToInfo(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyInfoPage(
                  ds: ds,
                )));
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

  /*final FirebaseAuth auth = FirebaseAuth.instance;
    inputData() async {// funcion para obtener el UID del usuario actual
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    print("UID del usuario actual: " + uid );//imprime el UID del usuario actual
    return uid;
  }*/
  /*void listar(DocumentSnapshot uid) async
  {
   
    await db.document('collection/$uid').get().then((DocumentSnapshot document){
       print("document_build:$document");
        setState(() {
         filtro=document["IsNewUser"];
         print("getIsNewUSe:$filtro"); 
        });

    });
  }
  */
  Future<DocumentSnapshot> getUserInfo() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    print("pasa firebaseuser " + firebaseUser.uid.toString());

    return await Firestore.instance
        .collection("collection")
        .document(firebaseUser.uid)
        .get();
  }

  colleccion(String filtro) {
    return Firestore.instance
        .collection('collection')
        .where('uid', isEqualTo: filtro.substring(0, 1))
        .getDocuments();
  }

   Future <bool> alert(){//genera un mensaje de alerta 
    return showDialog( 
      context:context,
      builder:(context)=>AlertDialog(
        title:Text("Precione el boton Home en esquina superior derecha"),
        actions:<Widget>[
          FlatButton(
            child:Text("OK"),
            onPressed:()=>Navigator.pop(context, false),
          ),
        ]
      )
    );
  }
   void showAlertDialogBack(DocumentSnapshot doc) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () => Navigator.pop(
          context), //al cancelar cierra el cuadro y se mantiene en la página
    );

   }
  @override
  Widget build(BuildContext context) {
    idCurrentUser(); 
    //Stream <QuerySnapshot> snap = Firestore.instance.collection('collection').snapshots();
    //var coleccion = Firestore.instance.collection('collection').snapshots();
    final coleccion = Firestore.instance
              .collection('collection')
              .where('uid', isEqualTo: uid)
              .getDocuments();
    //final Query dataUsuario = coleccion.map();
    //     coleccion.where((event) => event.documents.contains(uid));
    //  var dataUsuario = Firestore.instance.collection('collection').where('uid', isEqualTo: uid).snapshots();
    //  dataUsuario.length;
    //  print("datausuario length : " +dataUsuario.length.toString());

    // print(query);

    //print("here");

    int indexTotal = 0;
    CommonThings.size = MediaQuery.of(context).size;
    return WillPopScope(  
       
      onWillPop:alert,
      child: new Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false,// quita la fecha para regresar 
        title: Text('Administrar Servicios'),
        actions: <Widget>[
          //IconButton(
          // icon: Icon(Icons.list),
          // tooltip: 'List',
          // onPressed: () {
          //  Route route = MaterialPageRoute(builder: (context) => MyListPage());
          // Navigator.push(context, route);
          //},
          //),
          IconButton
          (
              icon: Icon
              (
                Icons.home,
                size: 40.0,
              ),
              onPressed: home),
          //IconButton(
          // icon: Icon(Icons.search,size: 40.0),
          // tooltip: 'Search',
          // onPressed: () {
          //  Route route = MaterialPageRoute(builder: (context) => MyQueryPage());
          // Navigator.push(context, route);
          //},
          // ),
        ],
      ),
      body: FutureBuilder(
          //StreamBuilder(

          //Firestore.instance
          //   .collection("collection")
          //   .where("uid", isEqualTo: "USA")
          //   .getDocuments()
          //   .then((value) {
          // value.documents.forEach((result) {
          //   print(result.data);
          // });
          //});
          // stream: coleccion,//Firestore.instance.collection('collection').snapshots(),
           future:coleccion,
          // future: Firestore.instance
          //     .collection('collection')
          //     .where('uid', isEqualTo: uid)
          //     .getDocuments(), //dataUsuario, //Firestore.instance.collection('collection').snapshots(),
          //stream: getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
            //builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print("hasta aquí: ");
            if (!snapshot.hasData) {
              return Center (child :CircularProgressIndicator()); //aparece el circulo cuando está cargando los datos
            }
            /* if (snapshot.connectionState == ConnectionState.done) 
                {
                  print("done");
                  return ListView.builder
                  (
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        //print("index original: " +index.toString());
                        //index=indexTotal;
                        //print("index total: " +index.toString());
                        print("antes de corchete");
                        //DocumentSnapshot doc = snapshot.data.data[index]; //obtiene los datos a mostrar en cada uno de los servicios en el resultado
                        //final DocumentSnapshot doc = snapshot.data.documents.where((element) => element.data["uid"]==uid).elementAt(index);
                        //print("index ="+indexTotal.toString());
                        //print("uid doc " +
                        //    doc.data["uid"] +
                         //   " = " +
                         //   uid.toString());
                        // print("uid doc "+doc.data["uid"]+" = "+ uid);
                        //while(doc.data["uid"]!=uid && indexTotal<length){
                        //  indexTotal++;
                        //  print("while index ="+indexTotal.toString());
                        //  print("no muestra uid doc "+doc.data["uid"]+" = " +uid.toString());
                        // doc = snapshot.data.documents[indexTotal];
                        //  }

                      // if (doc.data["uid"] == uid) {
                          print("muestra index =" + indexTotal.toString());
                          //print("muestra uid doc " +
                          //    doc.data["uid"] +
                           //   " = " +
                            //  uid.toString());
                          return new Container(
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () => navigateToDetail(snapshot.data),
                                        child: new Container(
                                          child: Image.network(
                                            '${snapshot.data.data["image"]}' +
                                                '?alt=media',
                                          ),
                                          width: 170,
                                          height: 120,
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data["name"],
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 19.0,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data["actividad"],
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12.0),
                                      ),
                                      onTap: () => navigateToDetail(snapshot.data),
                                    ),
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        child: new Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () => showAlertDialog(
                                                  snapshot.data), //funciona
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.blueAccent,
                                              ),
                                              onPressed: () =>
                                                  navigateToInfo(snapshot.data),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                       // } else {
                         // return null;
                        //}
                      });
                }
                

                int length = snapshot.data.documents.where((element) => element.data["uid"]==uid).length;
                //print("antes del length ");

                //int length = snapshot.data.data.length;
                //print("pasa length ");
                //var coleccion = Firestore.instance.collection('collection').snapshots();

                //coleccion.where((event) => event.documents.contains(uid));
                // DocumentSnapshot doc = snapshot.data.documents[indexTotal]; //obtiene los datos a mostrar en cada uno de los servicios en el resultado
                //while(doc.data["uid"]!=uid && indexTotal<length){
                //    indexTotal++;
                // print("while index ="+indexTotal.toString());
                //  print("no muestra uid doc "+doc.data["uid"]+" = " +uid.toString());
                // doc = snapshot.data.documents[indexTotal];
                //coleccion.elementAt(indexTotal);
                //coleccion.where((event) => event.documents.contains(uid));
                //}
                else if(snapshot.connectionState==ConnectionState.none)
                {
                    return Text("no data");
                }
                else
                {
                  return CircularProgressIndicator();
                }
                
                */
            int length = snapshot.data.documents.length;
            print("tamaño legth" + length.toString());
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //dos columnas
                  mainAxisSpacing: 0.1, //espacio de card
                  childAspectRatio: 0.800, //space largo de cada card
                ),
                itemCount: length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (_, int index) {
                  //print("index original: " +index.toString());
                  //index=indexTotal;
                  //print("index total: " +index.toString());
                  DocumentSnapshot doc = snapshot.data.documents[index]; //obtiene los datos a mostrar en cada uno de los servicios en el resultado
                  //final DocumentSnapshot doc = snapshot.data.documents.where((element) => element.data["uid"]==uid).elementAt(index);
                  //print("index ="+indexTotal.toString());
                  print("uid doc " + doc.data["uid"] + " = " + uid.toString());
                  // print("uid doc "+doc.data["uid"]+" = "+ uid);
                  //while(doc.data["uid"]!=uid && indexTotal<length){
                  //  indexTotal++;
                  //  print("while index ="+indexTotal.toString());
                  //  print("no muestra uid doc "+doc.data["uid"]+" = " +uid.toString());
                  // doc = snapshot.data.documents[indexTotal];
                  //  }

                  if (doc.data["uid"] == uid) {
                    print("muestra index =" + indexTotal.toString());
                    print("muestra uid doc " +
                        doc.data["uid"] +
                        " = " +
                        uid.toString());
                    return new Container(
                      color: Colors.blueGrey,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => navigateToDetail(doc),
                                  child: new Container(
                                    color: Colors.black12,
                                    child: Image.network(
                                      '${doc.data["image"]}' + '?alt=media',
                                    ),
                                    width: 186,
                                    height: 120,
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  doc.data["name"],
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 19.0,
                                  ),
                                ),
                                subtitle: Text(
                                  doc.data["actividad"],
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 12.0),
                                ),
                                onTap: () => navigateToDetail(doc),
                              ),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  child: new Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () =>
                                            showAlertDialog(doc), //funciona
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => navigateToInfo(doc),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => navigateToDetail(doc),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                   else {
                    //return Widget(child:WhitOutThing("empty"));
                   // return Container(height: 0.01,width: 0.01, );
                  return Container
                  (
             
                  );

                  }
                });
                
          }),
      floatingActionButton: FloatingActionButton
      (
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => MyAddPage());
          Navigator.push(context, route);
        },
      ),
       ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Buscar Actividad"),
        onChanged: (text) {
          text = text.toLowerCase();
          //setState(() {
          // _notes=_notes.where((note){
          // var noteTitle=note.title.toLowerCase();
          // return noteTitle.contais(text);
          //}).toList();
          // });
        },
      ),
    );
  }
}
