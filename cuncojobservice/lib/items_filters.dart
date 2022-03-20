import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemsFilters extends StatelessWidget {
  final Function(String) onFilterChange;

  const ItemsFilters({Key key, this.onFilterChange}) : super(key: key);

  void _onPressed() {
Firestore.instance
    .collection("collection")
    .where("uid", isEqualTo: "E2RtgU7ZYwQ46rZ8TmOy0dPj6cF2")
    .getDocuments()
    .then((value) {
  value.documents.forEach((result) {
    print(result.data);
    print("el resultado de la query es");
  });
});
}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 10),
          FlatButton(
            child: Text("Corte de leña"),
            color: Colors.white,
            onPressed: ()=>_onPressed 
          ),
          SizedBox(height: 10),
          FlatButton(
            child: Text("Carpinteria"),
            color: Colors.white,
            onPressed: () {
              onFilterChange("odd");
            },
          ),
           FlatButton(
            child: Text("Corte de leña"),
            color: Colors.white,
            onPressed: () {
              onFilterChange("odd");
            },
          ),
           FlatButton(
            child: Text("Costuras"),
            color: Colors.white,
            onPressed: () {
              onFilterChange("odd");
            },
          ),
           FlatButton(
            child: Text("Reposteria"),
            color: Colors.white,
            onPressed: () {
              onFilterChange("odd");
            },
          ),
           FlatButton(
            child: Text("Liempieza de cañones"),
            color: Colors.white,
            onPressed: () {
              onFilterChange("odd");
            },
          ),
        ],
      ),
    );
  }
}
