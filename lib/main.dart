import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final ThemeData kIOSTheme= new ThemeData(
  primaryColor: Colors.grey[100],
  primarySwatch: Colors.orange,
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme= new ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400]
);


void main(){
  runApp(new ChatApp());
}
class ChatApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Chat App",
      theme: debugDefaultTargetPlatformOverride == TargetPlatform.iOS
      ? kIOSTheme : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}
class ChatScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>new ChatScreenState();
}
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController=new TextEditingController();
  bool _isComposing =false;
  Widget _buildTextComposer(){
    return IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                onChanged: (String text){
                  setState(() {
                    _isComposing=true;
                  });
                },
                decoration: new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child:Theme.of(context).platform == TargetPlatform.iOS ?
                  new CupertinoButton(
                      child: new Text("Send"),
                      onPressed: _isComposing
                          ? ()=> _handleSubmitted(_textController.text)
                          :null,
                  ) :
                  new IconButton(
                      icon: new Icon(Icons.send),
                      onPressed: _isComposing ?
                      () => _handleSubmitted(_textController.text) : null
                  )
            ),
          ],
        ),
      ),
    );
  }
  void _handleSubmitted(String text){
    _textController.clear();
    setState(() {
      _isComposing=false;
    });
    ChatMessage message= new ChatMessage(
      text: text,
      animationController: new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 700),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat App"),
        elevation: Theme.of(context).platform ==TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body:
      Container(
        decoration: Theme.of(context).platform ==TargetPlatform.iOS
            ? new BoxDecoration(
          border: new Border(
            top: new BorderSide(color: Colors.grey[200]),
          )
        ) : null ,
        child: new Column(
          children: <Widget>[
            new Flexible(
                child:new ListView.builder(
                  itemBuilder:(_,int index)=>_messages[index],
                  itemCount: _messages.length,
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                ),
            ),
            new Divider(height: 1.0,),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor
                ),
              child: _buildTextComposer(),
              ),
          ],
        ),
      )
      );
  }
  @override
  void dispose() {
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  static const _name="Benantar Abdennour";
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(                                    //new
        sizeFactor: new CurvedAnimation(                              //new
            parent: animationController, curve: Curves.easeOut),      //new
        axisAlignment: 0.0,                                           //new
        child: new Container(                                    //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )                                                           //new
    );
  }
}