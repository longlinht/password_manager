import 'package:password_manager/ui/SetMasterPassword.dart';
import 'package:flutter/material.dart';

class GreetingPage extends StatefulWidget {
  @override
  GreetingPageState createState() => GreetingPageState();
}

class GreetingPageState extends State<GreetingPage> {


  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Image.asset("assets/password.png",height: size.height*0.3,),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8, 24, 8),
                child: Text("欢迎来到密码管理神器凯撒盒子!",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "Title", fontSize: 36)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8, 24, 8),
                child: Text(
                    "所有敏感的密码数据都将以高效，安全，极简的方式存储在你的手机上",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Subtitle",
                        fontSize: 18,
                        // color: Colors.black54
                        ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8, 24, 8),
                child: Text("设置你的主密码来开启凯撒盒子",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "Subtitle", fontSize: 24)),
              ), Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8, 24, 8),
                child: Text(
                    "(之后可修改)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Subtitle",
                        fontSize: 18,
                        // color: Colors.black54
                        ),
                        ),
              ),SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: size.width * 0.7,
                child: MaterialButton(
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)
                  ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SetMasterPassword()));
                    },
                    color: primaryColor,
                    child: Text("开始",
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
