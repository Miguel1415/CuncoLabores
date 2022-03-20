import 'dart:ui';
import 'package:cuncojobservice/auth_service.dart';
import 'package:cuncojobservice/main.dart';
import 'package:cuncojobservice/search.dart';
import 'package:cuncojobservice/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inside.dart';
import 'animaciones/FadeAnimations.dart';

class LoginPage extends StatefulWidget {
  final Function onLoginSuccess;
  const LoginPage({Key key, this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
  

//  signOut() {}
}
class _LoginPageState extends State<LoginPage> {
Future status() async// metodo para saltarse el loguin en caso de queel usuarios ya esté logueado
{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();//se obtiene el UID del usuario actual.
      if(user != null)//si el usuario es distinto de null, contigua con el codigo
      {
      // _succes=true;
      // userId= user.uid;
       Navigator.push
       (
        context,
        MaterialPageRoute(
           builder: (context) =>
               PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
       );

     }
     else
     {
       return null;
     }
}
  
  bool isLogged = false;
  bool _succes;
  String userId;
  bool isLoggedIn = false;
  Map userProfile;
  bool _isLoggedIn = false;
  final AuthService _auth= AuthService();//de la clase auth_service
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _authe = FirebaseAuth.instance;
  //Firestore _db = Firestore.instance;
  //FirebaseUser _user;
  //FacebookLogin _facebookLogin = FacebookLogin();
  final GoogleSignIn googleSignIn = GoogleSignIn();


  bool isSigIn = false;
  
  Future<FirebaseUser> _signInGoogleAccounts() async {
    //este metodo devuelve un future
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn(); //abre el selector de cuentas de google
      final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication; //si es correcto os devuelve uun google user que tiene como atributo un googleSignInAuthentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        //obtiene las credenciales
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _authe.signInWithCredential(credential); //se le pasa las credentiales a firebase auth
      final FirebaseUser user = authResult
          .user; //si es exitoso recibimos un user y podemos obtener datos de ellos
      print("signIn " + user.displayName); //en este caso el nombre del user
      Navigator.push(
        //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
      );
      return user;
    } catch (err) {}
    //assert(!user.isAnonymous);
    //assert(await user.getIdToken() != null);

    //final FirebaseUser currentUser = await _auth.currentUser();
    //assert(user.uid == currentUser.uid);

    //return 'signInWithGoogle succeeded: $user';
  }
  

  void handleSignIn() async {
   final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
   final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

   final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    final AuthResult authResult = await _authe.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(user.displayName!=null); 
    assert(await user.getIdToken() != null );

    print("signIn " + user.displayName);//muestra el nombre de la cuenta
    //print("signIn " + user.email);//muestra el correo de la cuenta       
    print("photo" + user.photoUrl);
    print("Usario:" +  user.uid);//obtiene el UID del usuario registrado
    

    final FirebaseUser currentUser=await _authe.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() 
     {
      if(user != null)
      {
       _succes=true;
       userId= user.uid;
       Navigator.push
       (
        //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
        context,
        MaterialPageRoute(
           builder: (context) =>
               PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
       );

     }
    }
   );
  }

  
Future <String>getCurrentUID()async
{
  return (await _authe.currentUser()).uid; //se obtiene el uid del usuario
}
Future getCurrentUser()async
{
  return (await _authe.currentUser());
  
}
  Future<void> googleSignout() async 
  {
    await _authe.signOut().then((value) 
    {
      _googleSignIn.signOut();
      setState(() {
        isSigIn = false;
      });
    });
  }

  _login() async {
    try {
      await _googleSignIn.signIn();
      print("inside");

      Navigator.push(
        //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
        context,
        MaterialPageRoute(
            builder: (context) =>
                LoginPage()), //envía a la siguenta pantalla en caso de ser logueado
      );
    } catch (err) {
      Navigator.push(
        //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
      );
    }
    setState(() {
      _isLoggedIn = false;
    });

    //} catch (err)
    //{
    //print(err);

    // }
    //}
  }

  /*Future<FirebaseUser> _loginWithTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: '1btDs9fU5mjfKMu5rZyV6cNcb',
      consumerSecret: 'tXexX2Q6I7fVL6h14z0lZivNkJZ8z1FWCTXRhd9dskN1wFdhA8',
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
  case TwitterLoginStatus.loggedIn:
    var session=result.session;
    final AuthCredential credential= TwitterAuthProvider.getCredential(
      authToken: session.token,
      authTokenSecret: session.secret
    );
    FirebaseUser firebaseUser=(await _auth.signInWithCredential(credential)).user;
    print("signIn " + firebaseUser.displayName);
    print("signIn " + firebaseUser.photoUrl);
    print("twitter sign in"+firebaseUser.toString());
    print("ingreso exitoso");
    Navigator.push(
        //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
      );
    break;
    
  case TwitterLoginStatus.cancelledByUser:
    break;
  case TwitterLoginStatus.error:
    break;
    }
    return null;
  }
  */

 


  FirebaseUser myUser;

  Future<FirebaseUser> _loginAsFacebook() async 
  {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logInWithReadPermissions(['email', 'public_profile']);

    final token = result.accessToken.token;
    final graphResponse = await http.get
    (
        // ignore: unnecessary_brace_in_string_interps
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');//se pueden obtener uno de estos datos
    final profile = json.decode(graphResponse.body);
    print(profile['email']); //en ese caso pedi que mostrara el email de la persona
    print(profile['first_name']); //en ese caso pedi que mostrara el primer nombre de la persona
    print(profile['last_name']);  //en se caso se pide que se muestre el apellido de la persona
    
   if(result.status == FacebookLoginStatus.loggedIn)//consulta si esta logueado
   {    
    
     AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
     AuthResult authResult = await _authe.signInWithCredential(credential);
     FirebaseUser _user = authResult.user;

      //metodo apra envio a siguente pagina
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

  void _logIn() 
  {
    _loginAsFacebook().then((response)
    {
      if (response != null) 
      {
        myUser = response;
        isLogged = true;
        setState(() {});
      }
    });
  }
void jump() async
  { 
    if(FirebaseAuth.instance.currentUser() != null)
    {
      // wrong call in wrong place!
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PaginaMenu()
      ));
    }
    else
    {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage()));
    }
  
  }

  @override
  Widget build(BuildContext context) {
   status();//llama el metodo para saltarse el loguin en caso de que esta loguedo el ususario
   //onWillPop:_onBackPressed,
      //child: new Scaffold(
    //bool isLoggedIn = false;

    void onLoginStatusChange(bool isLoggedIn) {
      setState(() {
        this.isLoggedIn = isLoggedIn;
      });
    }
  
  
  
   String _email;
   String _password;
   
    void validate() async {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
      
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(130, 144, 148, 90),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
                1.2,
                Text(
                  "Inicie sesión",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                )),
            FadeAnimation(
                1.2,
                Text(
                  "Seleccione el modo de inicio de sesión. ",
                  style: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 200,
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
                      
                      // Container(

                      //padding: EdgeInsets.all(30),
                      //decoration: BoxDecoration(
                      //borderRadius: BorderRadius.circular(50),
                      //color: Colors.blue[800]
                      // ),
                      // child: Center( child: isLoggedIn? ("Bienvenido")
                      // :RaisedButton(child: Text("Iniciar sesion con facebook "),
                      //color: Color.fromRGBO(50, 89, 159, 1),
                      // padding: EdgeInsets.all(30.0),

                      //  textColor: Colors.white,

                      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

                      // onPressed: ()=>initiateFacebookLogin())

                      //  ),

                      //  ),
                      //    Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FloatingActionButton.extended(
                              //boton para agregar los datos
                              heroTag: "jj",
                              backgroundColor: Color.fromRGBO(50, 89, 159, 1),
                              icon: Icon(FontAwesomeIcons.facebookF),
                              label: Text("Iniciar sesión con Facebook"),
                              onPressed: () => _loginAsFacebook())
                        ],
                      ),

                      Container(
                           padding: EdgeInsets.all(15),),//divider o el contariner y dentro de el, el  margin: EdgeInsets.only(top: 30)

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FloatingActionButton.extended(
                              //boton para agregar los datos
                              heroTag: "jjd",
                              backgroundColor: Color.fromRGBO(219, 74, 59, 1),
                              icon: Icon(FontAwesomeIcons.google),
                              label: Text("Iniciar sesión con Google    "),
                              onPressed: () => handleSignIn())
                        ],
                      ),
                     Container(
                           padding: EdgeInsets.all(15),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new FloatingActionButton.extended(
                              //boton para agregar los datos
                              heroTag: "jajd",
                              backgroundColor: Color.fromRGBO(130, 144, 148, 90),
                              icon: Icon(FontAwesomeIcons.user),
                              
                              label: Text("    Iniciar sesión anónimo    "),
                              onPressed: ()async 
                              {
                                dynamic result = await _auth.singInAnon();
                                if (result == null)
                                {
                                  print("error singnin in");
                                }
                                else
                                {
                                  print("sing in");
                                  print(result);
                                  Navigator.push
                                  (
                                  //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
                                   context,
                                   MaterialPageRoute(builder: (context) =>PaginaMenuAnon()), //envía a busqueda de servicios de manera directa en caso de ser logueado como anónimo
                                  );
                                }
                              })
                        ],
                      ),
                      

                      // Container(
                      //   child: isLogged            //boton de facebook en consola
                      //?null
                      //:FacebookSignInButton(
                      //onPressed: _loginAsFacebook,
                      //),
                      // )

                      //  Container(
                      //      margin: EdgeInsets.only(top: 30),//genera un espacio entre los dos botones

                      //     child: Center( child: isLoggedIn?("")
                      //   :RaisedButton(

                      //  child: Text("Iniciar sesion con google+ "),

                      // color: Color.fromRGBO(219, 74, 59, 1),
                      // padding: EdgeInsets.all(30.0),

                      // textColor: Colors.white,
                      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      //  onPressed: ()=>_login())

                      //  ),

                      //  ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}