import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tencent_youtuyun/utils/tencentYoutuYun/TXQcloudFrSDK.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File image;
  String name;
  String idCard;


  void _successBlock(Map response) {
    name = response['name'];
    idCard = response['id'];
    setState(() {

    });
  }

  void _failureBlock(dynamic data) {
    name = null;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Container(
        child: Stack(
          children: <Widget>[
            new Align(
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(name == null
                          ? 'images/icon_failed.png'
                          : 'images/icon_complete.png'),
                      new Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: new Text(
                          name == null
                              ? '识别失败'
                              : '识别成功',
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                  new Container(
                    width: 246,
                    height: 158,
                    child: new Stack(
                      children: <Widget>[
                        new Align(
                          alignment: AlignmentDirectional.center,
                          child: new Container(
                            width: 246,
                            height: 158,
                            child: image == null
                                ? Image.asset('images/pic_ida.png',fit: BoxFit.fill,)
                                :  Image.file(image,fit: BoxFit.fill),
                          ),
                        ),
                        new Align(
                          alignment: AlignmentDirectional.center,
                          child: new GestureDetector(
                            onTap: ()async {
                              image = await ImagePicker.pickImage(source: ImageSource.camera);
                              setState(() {

                              });
                              if(image!=null) {
                                //cardType  0-身份证正面  1-身份证背面
                                TXQcloudFrSDK.idcardOcrFaceIn(image, 0, _successBlock, _failureBlock);
                              }
                            },
                            child: new Center(
                              child: name == null
                                  ? Image.asset('images/btn_takephotopress.png')
                                  : new Container(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.fromLTRB(67, 43, 67, 30),
                    padding: EdgeInsets.fromLTRB(20, 13, 20, 13),
                    decoration: BoxDecoration(
                      color: name != null ? Color(0xFFF5FCFF) : Color(0x00000000),
                      borderRadius: BorderRadius.circular(7.0), //7像素圆角
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          name != null ? name : '',
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                        new Text(
                          name != null ? '身份证：${idCard}' : '',
                          style: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
