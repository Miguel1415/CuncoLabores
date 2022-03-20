import 'package:flutter/material.Dart';

class SearchList extends StatefulWidget {
  SearchList({ Key key }) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();

}

class _SearchListState extends State<SearchList>
{
  Widget appBarTitle = new Text("Buscar servicio", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    init();

  }

  void init() {
    _list = List();
    _list.add("Google");
    _list.add("IOS");
    _list.add("Andorid");
    _list.add("Dart");
    _list.add("Flutter");
    _list.add("Python");
    _list.add("React");
    _list.add("Xamarin");
    _list.add("Kotlin");
    _list.add("Java");
    _list.add("efasdasd");
    _list.add("RxAnwfgetterwfwedroid");
    _list.add("hryhryhy");
    _list.add("yujjyhr");
    _list.add("werwr");
    _list.add("plphlho");
    _list.add("fmkkjndj");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ? _buildSearchList() : _buildList(),
      ),
    );
  }
  
  List<ChildItem> _buildList() {
    return _list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact))
          .toList();
    }
    else {
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Buscar...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            }
          );
        },
       ),
      ]
    );
  }

  void _handleSearchStart() 
  {
    setState(() 
    {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() 
    {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Search Sample", style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}

class ChildItem extends StatelessWidget {
  final String name;
  ChildItem(this.name);
  @override
  Widget build(BuildContext context) 
  {
    return new ListTile(title: new Text(this.name));
  }

}
    /*
    return Scaffold(
        appBar: AppBar(
          
          
          title: Text('Buscar'),
        ),
        
        body :StreamBuilder(
           
          //stream: Firestore.instance.collection("colrecipes").document("GfeCyUfaNmBgIbrV9KVS").snapshots(),
          stream: Firestore.instance.collection("colrecipes").snapshots(),
          
       
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Text('"Loading...');
          }
          int length = snapshot.data.documents.length;
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //dos columnas
              mainAxisSpacing: 0.1, //space the card
              childAspectRatio: 0.800, //space largo de cada card
          ),
           itemCount: length,
            padding: EdgeInsets.all(2.0),
            itemBuilder: (_, int index) {
              final DocumentSnapshot doc = snapshot.data.documents[index];                         
              return new Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Divider(),//hace una divicion entre la imagen y la parte de arriva
                      
                      Row(
                        
                        children: <Widget>[
                          
                          InkWell(
                             //onTap: () => navigateToDetail(doc),//bloquea la parte de el edit de la donde se encuentra la fotografia de la publicación
                            child: new Container(
                              child: Image.network(
                                '${doc.data["image"]}' + '?alt=media',
                              ),
                              width: 170,
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
                                  // onPressed: () => navigateToInfo(doc),
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
    ); */     
  

/*

        body: new Form(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 17.0),
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.access_alarm),
                    hintText: 'Alguna cosa',
                   labelText: "cosa2"),
              ),
              SizedBox(
                height: 20.0,
              ),
              new StreamBuilder<QuerySnapshot>
              (
                 stream:
                    Firestore.instance.collection("colrecipes").snapshots(),
                  builder: (context, snapshot) {
                   return new DropdownButton(
                    items: snapshot.data.documents
                      .map((DocumentSnapshot document) {
                        return DropdownMenuItem(
                           child: new Text(document.data['actividad']));
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
        ),
        */
