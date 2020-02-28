import 'package:flutter/material.dart';
import 'package:flutter_app/baseAuth.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/HomePage.dart';
void main(){
  runApp(new RootPage(auth: new Auth()));
}

enum AuthStatus{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState()=>new _RootPageState();
}
class _RootPageState extends State<RootPage>
{
  AuthStatus authStatus=AuthStatus.NOT_DETERMINED;
  String _userId="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((user){
      setState(() {
        if(user != null){
          _userId=user?.uid;
        }
        authStatus=user?.uid ==null ? AuthStatus.NOT_LOGGED_IN :AuthStatus.LOGGED_IN;
      });
    });
  }
  void loginCallBack(){
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId=user.uid.toString();
      });
    });
    setState(() {
      authStatus=AuthStatus.LOGGED_IN;
    });
  }
  void logoutCallBack(){
    setState(() {
      authStatus=AuthStatus.NOT_LOGGED_IN;
      _userId="";
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth:widget.auth,
          loginCallBack: loginCallBack,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if(_userId.length >0 &&_userId!=null)
          {
            return new ChatApp(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallBack,
            );
          }
        else{
          return buildWaitingScreen();
        }
        break;
      default:
        return buildWaitingScreen();
    }

  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

}