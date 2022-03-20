import 'package:flutter/material.dart';
import 'package:cuncojobservice/consultas.dart';
import 'package:cuncojobservice/informationpage.dart';
import 'package:cuncojobservice/updatepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resultados',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new PaginaSearch(),
    );
  }
}

class CommonThings {
  static Size size;
}


class PaginaSearch extends StatefulWidget {
  get fade => null;

  _PaginaSearch createState() =>new _PaginaSearch();
  
        
}
class _PaginaSearch extends State<PaginaSearch> {
  /*
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  var selectedCurrency, selectedType;
  List<String> _accountType = <String>[
    'Cunco',
    'Melipeuco',
    'Vilcun',
    'Curacautín',
    'Lonquimay'
  ];
  
  var selectedCurrencye, selectedAct;
  List<String> _selectedAct = <String>[
    'Trekking',
    'Pesca',
    'Rafting',
    'Cabalgatas',
    'canopy'
  ];
  */
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  String id;
  final db = Firestore.instance;
  //final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;

  //create function for delete one register
   void deleteData(DocumentSnapshot doc) async {
    await db.collection('collection').document(doc.documentID).delete();
    setState(() => id = null);
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

 var selectedCurrencye, selectedAct;
  List<String> _selectedAct = <String>[
    'Limpieza de cañones',
    'Cortes de pasto',
    'Corte de leña',
    'Costuras',
    'Repostería',
    'fontanería'
  ];
  @override
  Widget build(BuildContext context) {
    
    
    CommonThings.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      appBar: AppBar(
        //title: Text('Resultados'),
        actions: <Widget>[  
                     
          IconButton(
           icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () { 
           Route route = MaterialPageRoute(builder: (context) => SearchList());
           Navigator.push(context, route);  //manda a otra pagina a buscar los datos        
         },
          ),
          
        ],    
      ),
      
      body: StreamBuilder(
        stream: Firestore.instance.collection("collection").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) 
          {
            return Center (child :CircularProgressIndicator()); //aparece el circulo cuando está cargando los datos
          }
          int length = snapshot.data.documents.length;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //dos columnas de resultados
              mainAxisSpacing: 0.1, //space the card
              childAspectRatio: 0.700, //space largo de cada card
          ),
            itemCount: length,
            padding: EdgeInsets.all(2.0),
            itemBuilder: (_, int index) 
            {
              final DocumentSnapshot doc = snapshot.data.documents[index];                         
              return new Container(
                 color: Colors.blueGrey,//rellena los bordes de los servicios ingresados
                child: Card(
                  child: Column(
                    children: <Widget>[
                        
                      Divider(),
                      //hace una divicion entre la imagen y la parte de arriva
                      Row(
                        children: <Widget>[                          
                          InkWell(
                             onTap: () => navigateToInfo(doc),//bloquea la parte de el edit de la donde se encuentra la fotografia de la publicación
                            child: new Container(//contenedor de la imagen
                            color: Colors.black12,
                              child: Image.network(
                                '${doc.data["image"]}' + '?alt=media',
                              ),
                              width: 186,
                              height: 150,
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
                              fontSize: 22.0,
                            ),
                          ),
                          subtitle: Text(
                            doc.data["actividad"],
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 15.0),
                          ),
                           onTap: () =>navigateToInfo(doc),// navigateToDetail
                        ),
                        
                        
                      ),
                      
                     // Divider(),
                      //Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //children: <Widget>[
                          //Container(
                            //child: new Row(
                              //children: <Widget>[
                                
                                //IconButton(
                                 // icon: Icon(
                                  //  Icons.remove_red_eye,
                                   // color: Colors.blueAccent,
                                  //),
                                   //onPressed: () => navigateToInfo(doc),
                                //),
                              //],
                            //),
                          //),
                        //],
                     // )
                     
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
    
     
    );
  }
}

        


