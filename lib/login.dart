import 'package:flutter/material.dart';
import 'package:flutter_app/baseAuth.dart';



class LoginSignupPage extends StatefulWidget{
  LoginSignupPage({this.auth,this.loginCallBack});
  final BaseAuth auth;
  final VoidCallback loginCallBack;

  @override
  State<StatefulWidget> createState()=>_LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage>{
  final _formkey =new GlobalKey<FormState>();
  bool _isLoading=false;
  bool _isLoginForm;
  String _password;
  String _email;
  String _errorMessage="";

  bool validateAndSave() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login Page',
      home: 
      Scaffold(
        appBar: new AppBar(
          title: new Text('Login'),
        ),
        body: new Stack(
          children: <Widget>[
            showForm(),
            showCircularProgress(),
          ],
        ),
      )
    );
  }
  Widget showCircularProgress(){
    if (_isLoading){
      return Center(child: CircularProgressIndicator(),);
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
  Widget showLogo (){
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.jpg'),
        ),
      ),
    );
  }
  Widget showEmailInput(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          )
        ),
        validator: (value)=>value.isEmpty ?'Email can\'t be emtpy': null,
        onSaved: (value) => _email=value.trim(),
      ),
    );
  }
  Widget showPasswordInput(){

    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          )
        ),
        validator: (value)=>value.isEmpty?'Password can\'t be empty':null,
        onSaved: (value) =>_password=value.trim(),
      ),
    );
  }
  Widget showPrimaryButton(){

    return new Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
          ),
          color: Colors.blue,
          child: new Text(_isLoginForm ? 'Login' : 'Create Account',
            style: new TextStyle(fontSize: 20.0,color: Colors.white),),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }
  void validateAndSubmit() async {
    setState(() {
      _errorMessage="";
      _isLoading=true;
    });
    if(validateAndSave())
      {
        String userId="";
        try{
          if(_isLoginForm)
            {
              userId=await  widget.auth.signIn(_email, _password);
              print('Signed in user:$userId');
            }
          else{
              userId=await widget.auth.signUp(_email, _password);
              print("Signed up user: $userId");
          }
          setState(() {
            _isLoading=false;
          });
          if(userId.length>0 && userId!=null && _isLoginForm)
            {
              widget.loginCallBack();
            }
        }catch(e){
          print('Error :$e');
          setState(() {
            _isLoading=false;
            _errorMessage=e.toString();
            _formkey.currentState.reset();
          });
        }
      }
  }
  Widget showSecondaryButton(){
    return new FlatButton(
        child: new Text(
          _isLoginForm ? 'Create new account' : 'Have an account ? Sign in now',
          style: new TextStyle(fontSize: 18.0,fontWeight: FontWeight.w300),
        ),
        onPressed: toggleFormMode,
        );
  }
  void toggleFormMode(){
    resetForm();
    setState(() {
      _isLoginForm=!_isLoginForm;
    });
  }
  void resetForm() {
    _formkey.currentState.reset();
    _errorMessage = "";
  }
  Widget showErrorMessage(){
    if(_errorMessage.length>0 && _errorMessage !=null)
      {
        return new Text(_errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),

        );
      }
    else{
      return new Container(
        height: 0.0,
      );
    }
  }
  Widget showForm(){
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formkey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    _errorMessage="";
    _isLoading=false;
    _isLoginForm=true;
    super.initState();
  }


}