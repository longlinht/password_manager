import 'package:password_manager/db/Database.dart';
import 'package:password_manager/model/PasswordModel.dart';
import 'package:password_manager/ui/PasswordHomepage.dart';
import 'package:password_manager/util/random_string.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import 'package:password_strength/password_strength.dart';

class AddPassword extends StatefulWidget {
  AddPassword({Key key}) : super(key: key);

  AddPasswordState createState() => AddPasswordState();
}

class AddPasswordState extends State<AddPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController appNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  Color pickedColor;
  var localAuth = LocalAuthentication();

  encrypt.Encrypted encrypted;
  String keyString = "";
  String encryptedString = "";
  String decryptedString = "";
  String masterPassString = "";
  int pickedIcon;

  List<Icon> icons = [
    Icon(Icons.account_circle, size: 28, color: Colors.white),
    Icon(Icons.account_balance, size: 28, color: Colors.white),
    Icon(Icons.card_membership_rounded, size: 28, color: Colors.white),
    Icon(Icons.work_rounded, size: 28, color: Colors.white),
    Icon(Icons.access_alarms, size: 28, color: Colors.white),
    Icon(Icons.ac_unit, size: 28, color: Colors.white),
    Icon(Icons.accessible, size: 28, color: Colors.white),
    Icon(Icons.add_circle_outline, size: 28, color: Colors.white),
    Icon(Icons.airline_seat_individual_suite, size: 28, color: Colors.white),
    Icon(Icons.assessment, size: 28, color: Colors.white),
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

  List<Color> colors = [
    Colors.red,
    // Color(0xffd5563a),
    Color(0xffcf5a3b),
    // Color(0xffca5d3c),
    // Color(0xffc6603d),
    // Color(0xffc0643d),
    Color(0xffba673e),
    // Color(0xffb66a3f),
    // Color(0xffb36c3f),
    // Color(0xffaf6e40),
    Color(0xffa87341),
    // Color(0xffa47642),
    Color(0xffa07842),
    // Color(0xff9b7b43),
    // Color(0xff967f44),
    // Color(0xff908245),
    Color(0xff8b8646),
    // Color(0xff858a47),
    Color(0xff808d47),
    // Color(0xff799249),
    // Color(0xff769349),
    // Color(0xff72964a),
    Color(0xff6d994a),
    // Color(0xff6c9a4a),
    // Color(0xff659e4c),
    // Color(0xff639f4c),
    Color(0xff5ea34d),
    // Color(0xff5ba44d),
    Color(0xff58a64e),
    // Color(0xff53aa4e),
    Colors.green
  ];

  // Future<Null> getMasterPass() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String masterPass = prefs.getString('master') ?? "";
  //   masterPassString = masterPass;
  // }

  Future<Null> getMasterPass() async {
    final storage = new FlutterSecureStorage();
    String masterPass = await storage.read(key: 'master') ?? '';
    masterPassString = masterPass;
  }

  authenticate() async {
    try {
      var localAuth = LocalAuthentication();
      print(await localAuth.getAvailableBiometrics());
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: '请验证后添加新密码',
      );

      print(didAuthenticate);

      if (didAuthenticate == false) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PasswordHomepage()),
            (Route<dynamic> route) => false);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }

  double passwordStrength = 0.0;
  Color passwordStrengthBarColor = Colors.black12;
  bool obscureText = true;
  String show_hide = '显示密码';
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pickedColor = Colors.black87;
    getMasterPass();
    pickedIcon = 0;
    // authenticate();
    super.initState();
  }

  checkPassStrength(String pass) {
    setState(() {
      passwordStrength = estimatePasswordStrength(pass);
      Color passwordStrengthBarColor = Colors.black12;
      if (passwordStrength < 0.4) {
        passwordStrengthBarColor = Colors.black26;
      } else if (passwordStrength > 0.4 && passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.black38;
      } else if (passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.black45;
      } else if (passwordStrength > 0.7 || passwordStrength == 0.7) {
        passwordStrengthBarColor = Colors.black87;
      }
      setState(() {
        this.passwordStrengthBarColor = passwordStrengthBarColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Text(
                  "新密码",
                  style: TextStyle(
                      fontFamily: "Title", fontSize: 28, color: primaryColor),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "标题",
                          labelStyle: TextStyle(fontFamily: "Subtitle"),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      controller: appNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "用户名/电子邮件",
                          labelStyle: TextStyle(fontFamily: "Subtitle"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                          ),
                      ),
                      controller: userNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter valid password';
                      //   }
                      // },
                      onChanged: (pass) {
                        checkPassStrength(pass);
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        // errorText: 'Please enter valid password',
                        labelText: "密码",
                        labelStyle: TextStyle(fontFamily: "Subtitle"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            String pass = randomAlphaNumeric(10);
                            passwordController.text = pass;
                            checkPassStrength(pass);
                          },
                          child: Text('生成'),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                              if (obscureText) {
                                show_hide = '显示密码';
                              } else {
                                show_hide = '隐藏密码';
                              }
                            });
                          },
                          child: Text(show_hide),
                        ),
                        FlatButton(
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text: passwordController.text));
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("已复制到剪切板"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('复制'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 10,
                        width: passwordStrength == 0
                            ? 0
                            : MediaQuery.of(context).size.width *
                                passwordStrength,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: passwordStrengthBarColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Text(
                            "选择一个图标",
                            style: TextStyle(
                                fontFamily: 'Title',
                                fontSize: 20,
                                color: primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Material(
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: CircleAvatar(
                                backgroundColor: pickedColor,
                                radius: 25,
                                child: icons[pickedIcon]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 24, 10),
                    child: GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 5,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.3,
                        children: List.generate(icons.length, (index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                pickedIcon = index;
                              });
                            },
                            child: Material(
                                color: pickedColor,
                                shape: CircleBorder(),
                                child: icons[index]),
                          );
                        }))
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.create),
        onPressed: () {
          if(appNameController.text.isEmpty) {
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("请输入正确的标题"),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          if(passwordController.text.isEmpty) {
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("请输入正确用户名"),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          encryptPass(passwordController.text);
          Password password = new Password(
              appName: appNameController.text,
              password: encryptedString,
              color: "#" + pickedColor.value.toRadixString(16),
              icon: iconNames[pickedIcon],
              userName: userNameController.text);
          DBProvider.db.newPassword(password);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PasswordHomepage()),
                  (Route<dynamic> route) => false);
        },
      ),
    );
  }

  _openColorPicker() async {
    Color _tempShadeColor = pickedColor;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("颜色选择器"),
          actions: [
            FlatButton(
              child: Text('取消'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  pickedColor = _tempShadeColor;
                });
              },
            ),
          ],
          content: MaterialColorPicker(
            allowShades: true,
            selectedColor: _tempShadeColor,
            onColorChange: (color) => setState(() => _tempShadeColor = color),
            onMainColorChange: (color) =>
                setState(() => _tempShadeColor = color),
          ),
        );
      },
    );
  }

  encryptPass(String text) {
    keyString = masterPassString;
    if (keyString.length < 32) {
      int count = 32 - keyString.length;
      for (var i = 0; i < count; i++) {
        keyString += ".";
      }
    }
    final key = encrypt.Key.fromUtf8(keyString);
    final plainText = text;
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final e = encrypter.encrypt(plainText, iv: iv);
    encryptedString = e.base64.toString();
  }
}
