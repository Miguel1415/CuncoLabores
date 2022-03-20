import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';



enum LoginProvider
{
  GOOGLE,
  FACEBOOK,
}
class LoginState with  ChangeNotifier
{
  final  GoogleSignIn _googleSignIn =GoogleSignIn();
  final FirebaseAuth _auth =FirebaseAuth.instance;
  SharedPreferences _prefs;

  bool _loggedIn =false;
  bool _loading =true;
  FirebaseUser _user;

  LoginState()
  {
    loginState();
  }
  bool isLoggedIn() => _loggedIn;
  bool isLoading()=> _loading;

  FirebaseUser currentUser()=>_user;

  void login (LoginProvider loginProvider)async
  {
    _loading = true;
    notifyListeners();

    switch(loginProvider)
    {
    case LoginProvider.GOOGLE:
   _user = await _handleSingIn();
    break;

   case LoginProvider.FACEBOOK:
   _user =await _handleFacebookSingIn();
   break;
    }
    _user = await _handleSingIn();

    _loading=false;
    if (_user!=null) 
    {
      _prefs.setBool('isLogginIn', true);
      _loggedIn =true;
      notifyListeners();
      
    } else 
    {
      _loggedIn=false;
      notifyListeners();
    }
  }
  void logout()
  {
    _prefs.clear();
    _googleSignIn.signOut();
    _loggedIn=false;
    notifyListeners();
  }

  Future <FirebaseUser> _handleFacebookSingIn()async{
     
       
    
      
    

    return null;

  }


  Future<FirebaseUser> _handleSingIn()async
  {
    final GoogleSignInAccount googleUser =await _googleSignIn.signIn();
    if(googleUser==null)
    {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =await googleUser.authentication;

    final AuthCredential credential =GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,);

   final AuthResult authResult = await _auth.signInWithCredential(credential);//se le pasa las credentials a firebase auth
  final FirebaseUser user = authResult.user;//si es exitoso recibimos un user y podemos obtener datos de ellos
  print("signIn " +user.displayName);//en este caso el nombre del user
    return user;
  }

  void loginState() async
  {
    _prefs=await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      _user=await _auth.currentUser();
      _loggedIn = _user !=null;
      _loading =false;
    }
  }


}
