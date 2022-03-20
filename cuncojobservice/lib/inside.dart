
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuncojobservice/LoginPage.dart';
import 'package:cuncojobservice/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'add.dart';
import 'animaciones/FadeAnimations.dart';

class PaginaMenu extends StatefulWidget {
  get fade => null;

  _PaginaMenu createState() => new _PaginaMenu();
}

bool isLoggedIn = false;
bool isLogged = false;

class _PaginaMenu extends State<PaginaMenu> {
  bool isLogged = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Map userProfile;

  
  void logOut() async { 
    var facebookLogin = new FacebookLogin();
    await facebookLogin.logOut();
    await _auth.signOut();
    _auth = null;

    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) =>
              LoginPage()), //envía a la siguenta pantalla en caso de ser logueado
    );
    //Future<GoogleSignInAccount> disconnected() async
   // {
    //  await _auth.signOut();

    //  return _googleSignIn?.disconnected();
    //}
    // _googleSignIn.signOut();
    //setState(() {
    // _isLoggedIn = true;
    //});
    /////await _auth.signOut().then((response) 
    ////{
     //// isLogged = false;
     // //setState(() {});
    ////});
//_auth.signOut().then((response){
    //    isLogged = true;
    //  setState(() {
    //});
    //});
    
  }

  void onLoginStatusChange(bool isLoggedIn) 
  {
    setState(() {});
  }

  void next() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
             PaginaSearch()), //envía a la siguente pantalla en caso de ser logueado
    )
    ;
  }

  void next2() async {
    Navigator.push(
      context,
      MaterialPageRoute(
         builder: (context) =>
            MyAddPage()), //envía a la siguente pantalla en caso de ser logueado
    )
    ;
  }

  FirebaseUser myUser;
  Future<FirebaseUser> _loginAsFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logInWithReadPermissions(['email']);

    debugPrint(result.status.toString());
    if (result.status == FacebookLoginStatus.loggedIn) {
      AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
      AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser _user = authResult.user;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
      );
      return _user;
    }
    return null;
  }

  Future <bool> alert(){ 
    return showDialog( 
      context:context,
      builder:(context)=>AlertDialog(
        title:Text("estas seguro de salir de la aplicación? "),
        actions:<Widget>[
          FlatButton(
            child:Text("No"),
            onPressed:()=>Navigator.pop(context, false),
          ),
          FlatButton(
            child:Text("Si"),
            onPressed:()=>exitApp(),//al precionar ejecuta el logout
          ),
        ]
      )
    );
  }

 void exitApp()//cerrar la aplicación (me falta la parte de precionar el boton y la llamada a este metodo)
 {
  Future.delayed(const Duration(milliseconds: 300), () //se define el tiempo en el cual se cierra la app
       {
         SystemChannels.platform.invokeMethod('SystemNavigator.pop');
       });
 }
  //WillPopScope()
  
  @override
  Widget build(BuildContext contex) {
  
  return WillPopScope(  
       
      onWillPop:alert,
      child: new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.exit_to_app), // se elige el icono que tendrá el boton exit
      onPressed: () => logOut()),
      
      
      
      backgroundColor: Color.fromRGBO(130, 144, 148, 90),
      body: Center(
       // padding: EdgeInsets.all(30),
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            FadeAnimation(
                1.5,
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.white
                  ),
                    child: Column(
                
                    children: <Widget>[
                      FadeAnimation(//sector donde se efectua la transición
                          1.3,//ajusta el tiempo de la transición
                          Text(
                            "Seleccione el método que deseas usar",
                            style: TextStyle(
                                color: Colors.white.withOpacity(.9),
                                height: 1.4,
                                fontSize: 30),
                          )),
                      SizedBox(
                        height: 70,//ajusta el texto de arriba 
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, right: 50, left: 50),
                        //padding: EdgeInsets.all(30),
                        //decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(70),
                        //  color: Colors.blue[800]),
                        child: Center(
                            child: Center(
                                child: isLoggedIn
                                    ? ("s")
                                                 
                 
                                    : RaisedButton(
                                        child: Icon(Icons.search,
                                            size: 130,
                                            color: Colors
                                                .white), //genera un espacio entre los dos contenedores
                                        //color: Colors.blue[800],

                                        color: Color.fromRGBO(79, 184, 38, 100),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        onPressed: () => next()))),
                      ),
                      Container(
                        
                      ),
                      
                      FadeAnimation(
                          1.3,
                          Text(
                            "Buscar Servicio",
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),//define el color y la opacidad de las letras
                                height: 1.4,
                                fontSize: 30),//tamaño de las letras
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              top: 20,
                              right: 50,
                              left:
                                  50), //genera un espacio entre los dos contenedores
                          //padding: EdgeInsets.all(30),
                          //decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(70),
                          // color: Colors.red[800]),
                          child: Center(
                              child: isLoggedIn
                                  ? ("s")
                                  : RaisedButton(
                                      child: Icon(Icons.arrow_upward,
                                          size: 130, color: Colors.white),
                                      // color: Colors.red[800],
                                      color: Color.fromRGBO(200, 29, 29, 1),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      onPressed: () => next2()))
                                      
                                      ),
                                       
                                    
                      FadeAnimation(
                          1.3,
                          Text(
                            "Subir Servicio",
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                height: 1.4,
                                fontSize: 30),
                          )),
                      
                          FadeAnimation(
                          1.3,
                          Text(//texto nulo 
                            "",
                            
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              top: 80,
                              right: 50,
                              left:50,
                              ), //genera un espacio entre los dos contenedores
                          //padding: EdgeInsets.all(30),
                          //decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(70),
                          // color: Colors.red[800]),
                          
                                      
                                      ),
                    ],
                  ),
                
                  
                ),
                
                ),
          ],
        ),
      ),
      ),
    );
  }
  
}
