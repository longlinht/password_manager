import 'package:password_manager/model/PasswordModel.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:flutter/services.dart';

import 'PasswordHomepage.dart';

class ViewPassword extends StatefulWidget {
  final Password password;

  const ViewPassword({Key key, this.password}) : super(key: key);

  @override
  ViewPasswordState createState() => ViewPasswordState(password);
}

class ViewPasswordState extends State<ViewPassword> {
  final Password password;
  ViewPasswordState(this.password);

  TextEditingController masterPassController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Icon> icons = [
    Icon(Icons.account_circle, size: 64, color: Colors.white),
    Icon(Icons.add, size: 64, color: Colors.white),
    Icon(Icons.access_alarms, size: 64, color: Colors.white),
    Icon(Icons.ac_unit, size: 64, color: Colors.white),
    Icon(Icons.accessible, size: 64, color: Colors.white),
    Icon(Icons.account_balance, size: 64, color: Colors.white),
    Icon(Icons.add_circle_outline, size: 64, color: Colors.white),
    Icon(Icons.airline_seat_individual_suite, size: 64, color: Colors.white),
    Icon(Icons.arrow_drop_down_circle, size: 64, color: Colors.white),
    Icon(Icons.assessment, size: 64, color: Colors.white),
  ];

  List<String> iconNames = [
    "Icon 1",
    "Icon 2",
    "Icon 3",
    "Icon 4",
    "Icon 5",
    "Icon 6",
    "Icon 7",
    "Icon 8",
    "Icon 9",
    "Icon 10",
  ];
  bool decrypt = false;
  String decrypted = "";
  Color color;
  int index;
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 9), radix: 16) + 0xFF000000);
  }

  bool didAuthenticate = false;

  authenticate() async {
    var localAuth = LocalAuthentication();
    didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: '请验证后查看密码',
        stickyAuth: true);
  }

  Future<String> getMasterPass() async {
    final storage = new FlutterSecureStorage();
    String masterPass = await storage.read(key: 'master') ?? '';
    return masterPass;
  }

  @override
  void initState() {
    print(password.color);
    color = hexToColor(password.color);
    index = iconNames.indexOf(password.icon);
    authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    icons[index],
                    SizedBox(
                      height: 12,
                    ),
                    Text(password.appName,
                        style: TextStyle(
                            fontFamily: "Title",
                            fontSize: 28,
                            color: Colors.white)),
                  ],
                ),
              )),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "用户名",
                      style: TextStyle(fontFamily: 'Title',
                          fontSize: 28),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                    child: Text(
                      password.userName,
                      style: TextStyle(
                        fontFamily: 'Subtitle',
                        fontSize: 18,
                        // color: Colors.black54
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "密码",
                              style: TextStyle(fontFamily: 'Title', fontSize: 28),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                            child: Text(
                              decrypt ? decrypted : "************",
                              style: TextStyle(
                                fontFamily: 'Subtitle',
                                fontSize: 18,
                                // color: Colors.black54
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () async {
                          if (!decrypt && !didAuthenticate) {
                            buildShowDialogBox(context);
                          } else if (!decrypt && didAuthenticate) {
                            String masterPass = await getMasterPass();
                            decryptPass(password.password, masterPass, true);
                          } else if (decrypt) {
                            setState(() {
                              decrypt = !decrypt;
                            });
                          }
                        },
                        icon: decrypt ? Icon(Icons.lock_open) : Icon(Icons.lock),
                      )
                    ],
                  ),
                ],
              ),
            )

          ),
          Padding(
            padding: const EdgeInsets.all(46.0),
            child: Center(
              child: SizedBox(
                width: size.width * 0.7,
                height: 60,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: primaryColor,
                  child: Text(
                    "复制",
                    style: TextStyle(color: Colors.white, fontFamily: "Title"),
                  ),
                  onPressed: () async {
                    String masterPass = await getMasterPass();
                    Clipboard.setData(new ClipboardData(
                        text: decryptPass(password.password, masterPass, false)));
                    scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text("密码已复制到剪切板"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  Future buildShowDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("请输入主密码"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "输入主密码查看:",
                style: TextStyle(fontFamily: 'Subtitle'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  maxLength: 32,
                  decoration: InputDecoration(
                      hintText: "主密码",
                      hintStyle: TextStyle(fontFamily: "Subtitle"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16))),
                  controller: masterPassController,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                decryptPass(
                    password.password, masterPassController.text.trim(), true);
                masterPassController.clear();
                if (!decrypt) {
                  final snackBar = SnackBar(
                    content: Text(
                      '主密码错误',
                      style: TextStyle(fontFamily: "Subtitle"),
                    ),
                  );
                  scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
              child: Text("完成"),
            )
          ],
        );
      },
    );
  }

  String decryptPass(String encryptedPass, String masterPass, bool changeState) {
    String keyString = masterPass;
    if (keyString.length < 32) {
      int count = 32 - keyString.length;
      for (var i = 0; i < count; i++) {
        keyString += ".";
      }
    }

    final iv = encrypt.IV.fromLength(16);
    final key = encrypt.Key.fromUtf8(keyString);

    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final d = encrypter.decrypt64(encryptedPass, iv: iv);

      if(changeState) {
        setState(() {
          decrypted = d;
          decrypt = true;
        });
      }
      return d;
    } catch (exception) {
      setState(() {
        decrypted = "主密码错误";
      });
    }
  }
}
