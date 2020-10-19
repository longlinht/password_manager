import 'package:password_manager/ui/PasswordHomepage.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SetMasterPassword extends StatefulWidget {
  @override
  SetMasterPasswordState createState() => SetMasterPasswordState();
}

class SetMasterPasswordState extends State<SetMasterPassword> {
  TextEditingController masterPassController = TextEditingController();

  Future<Null> getMasterPass() async {    

    final storage = new FlutterSecureStorage();   
    String masterPass = await storage.read(key: 'master') ?? '';
    masterPassController.text = masterPass;

  }

  saveMasterPass(String masterPass) async{
    final storage = new FlutterSecureStorage();   

    await storage.write(key: 'master', value: masterPass);
  }

  authenticate() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: '请验证后改变主密码',
        stickyAuth: true);

    if (!didAuthenticate) {
      Navigator.pop(context);
    }

    print(didAuthenticate);
  }

  @override
  void initState() {
    super.initState();
    authenticate();
    getMasterPass();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Text("主密码",
                    style: TextStyle(
                      fontFamily: "Title",
                      fontSize: 28,
                      color: primaryColor
                    ))),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  "给你的所有密码设置主密码，保管好主密码，之后可以用主密码来解密查看所有的其他密码",
                  style: TextStyle(
                      fontSize: 16,
                      // color: Colors.black54,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Subtitle"))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                obscureText: true,
                maxLength: 32,
                decoration: InputDecoration(
                    labelText: "主密码",
                    labelStyle: TextStyle(fontFamily: "Subtitle"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
                controller: masterPassController,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: size.width * 0.7,
                height: 60,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: primaryColor,
                  child: Text(
                    "确定",
                    style: TextStyle(color: Colors.white, fontFamily: "Title"),
                  ),
                  onPressed: () async {
                    if (masterPassController.text.isNotEmpty) {
                      saveMasterPass(masterPassController.text.trim());
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PasswordHomepage()));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "错误!",
                                style: TextStyle(fontFamily: "Title"),
                              ),
                              content: Text(
                                "请输入正确的主密码",
                                style: TextStyle(fontFamily: "Subtitle"),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("关闭"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
