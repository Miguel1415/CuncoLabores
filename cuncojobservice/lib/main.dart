import 'package:cuncojobservice/inside.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'animaciones/FadeAnimations.dart';
import 'package:cuncojobservice/LoginPage.dart';


void main() => runApp(
  
  MaterialApp(
    title:'Cunco Labores',
    debugShowCheckedModeBanner: false,
    home: HomePage()
  )

 
);
class HomePage extends StatefulWidget {
  @override
  
  _HomePageState createState() => _HomePageState();

bool loggedIn = false;
       
}


class _HomePageState extends State<HomePage> with TickerProviderStateMixin
{

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
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  bool hideIcon = false;
  String userId;
  bool _succes;
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _authe = FirebaseAuth.instance;


 void navigateUser() async
 {//metodo para iniciar sin preguntar sesion, pero no está implementado aún
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    if (status) 
    {
       Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HomePage()));
    }
    else
    {
       Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginPage()));
    }
  }
 
 

  @override

  void initState() 
  {
    super.initState();
 
    _scaleController = AnimationController
    (
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
     
    _scaleAnimation = Tween<double>(
      begin: 1.0, end: 0.8
    ).animate(_scaleController)..addStatusListener((status) 
    {
      if (status == AnimationStatus.completed) 
      {
        _widthController.forward();
      }
    });

    _widthController = AnimationController(//controla la animacion del circulo flecha
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    _widthAnimation = Tween<double>(
      begin: 80.0,
      end: 300.0
    ).animate(_widthController)..addStatusListener((status) 
    {
      if (status == AnimationStatus.completed) 
      {
        _positionController.forward();
      }
    });

    _positionController = AnimationController(//controla la animacion del circulo flecha
      vsync: this,
      duration: Duration(milliseconds: 700)
    );

    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 215.0
    ).animate(_positionController)..addStatusListener((status) 
    {
      if (status == AnimationStatus.completed) 
      {
        setState(() {
          hideIcon = true;
        });
        _scale2Controller.forward();
      }
    });

    _scale2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );

    _scale2Animation = Tween<double>(
      begin: 1.0,
      end: 32.0
    ).animate(_scale2Controller)..addStatusListener((status) 
    {
            if (status == AnimationStatus.completed) 
            {
        Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LoginPage()));//envia a pagina de login
      }
    });
  }
     /*void jump() async
  {
   final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
   final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final AuthResult authResult = await _authe.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    final FirebaseUser currentUser=await _authe.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() 
    {
    if(user != null)
    {
      _succes=true;
      userId= user.uid;
      Navigator.push(
      //el navigator.push lo puse dentro del catch, asi si no se puede loguear, regresa a la misma pantalla
      context,
      MaterialPageRoute(
          builder: (context) =>
              PaginaMenu()), //envía a la siguenta pantalla en caso de ser logueado
    );

 }
 });
  }
*/







final auth = FirebaseAuth.instance;
  @override

  Widget build(BuildContext context) 
{
  
    SystemChrome.setPreferredOrientations
    (
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]//permite que se bloquee la rotacion de la pantalla en la aplicación dejandola en vertical solamente
    );
    
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(130, 144, 148, 90),
      body: Container(
        width: double.infinity,
        child: Stack(
          children: <Widget>[
             //new Image.asset("assets/images/bulb.jpg"),
              Positioned(
              top: -50,
              left: 0,
              child: FadeAnimation(1, Container(
                width: width,
                height: 400,
               // decoration: BoxDecoration(
                 // image: DecorationImage(
                   // image: AssetImage('icons/one.png'),  
                    //fit: BoxFit.cover
                 //)
                //),
              )),
            ),
            Positioned(
              top: -100,
              left: 0,
              child: FadeAnimation(1.3, Container(
                width: width,
                height: 400,
               // decoration: BoxDecoration(
                 // image: DecorationImage(
                   // image: AssetImage('icons/one.png'),
                    //fit: BoxFit.cover
                 // )
                //),
              )),
            ),
            //Positioned(
              //top: -150,
              //left: 0,
              //child: FadeAnimation(1.6, Container(
                //width: width,
                //height: 400,
                //decoration: BoxDecoration(
                 // image: DecorationImage(
                  //  image: AssetImage('icons/one.png'),
                   // fit: BoxFit.cover
                 // )
                //),
             // )),
            //),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1, Text("Bienvenido a CuncoLabores", 
                  style: TextStyle(color: Colors.white, fontSize: 50),)),
                  SizedBox(height:120,),
                  FadeAnimation(1.3, Text("Busca y publica de forma fácil y rápida servicios de faenas y labores en la Comuna de Cunco.", 
                  style: TextStyle(color: Colors.white.withOpacity(.7), height: 1.4, fontSize: 20),)),
                  SizedBox(height: 20,),
                  FadeAnimation(1.3, Text("Presione la flecha para continuar...", 
                  style: TextStyle(color: Colors.white.withOpacity(.7), height: 1.4, fontSize: 20),)),
                  SizedBox(height: 150,),
                  FadeAnimation(2.6, AnimatedBuilder(//controla la velocidad de la caida del circulo de la flecha
                    animation: _scaleController,
                    builder: (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Center(
                      child: AnimatedBuilder( 
                        animation: _widthController,
                        builder: (context, child) => Container(
                          width: _widthAnimation.value,
                          height: 80,//largo del circulo que contiene el circulo de la flecha
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),//define el angulo del circulo
                           // backgroundColor: Color.fromRGBO(130, 144, 148, 90),
                            color: Colors.black.withOpacity(.4)// agrega color al segundo circulo de la clecha de abajo
                          ),
                          child: InkWell(
                            onTap: () {
                              _scaleController.forward();
                            },
                            child: Stack(
                              children: <Widget> [
                                AnimatedBuilder(
                                  animation: _positionController,
                                  builder: (context, child) => Positioned(
                                    left: _positionAnimation.value,
                                    child: AnimatedBuilder(
                                      animation: _scale2Controller,
                                      builder: (context, child) => Transform.scale(  
                                        scale: _scale2Animation.value,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,//hace que la flechita sea de forma circular
                                            color: Colors.black//agrega color a la circulo interno de la flecha
                                          ),
                                          child: hideIcon == false ? Icon(Icons.arrow_forward, color: Colors.white,) : Container(),
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),
                      ),
                    )),
                  )),
                  SizedBox(height: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
