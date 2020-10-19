import 'package:password_manager/ui/SetMasterPassword.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;
  Color selectedColor = Colors.red;

  openSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (Color(prefs.getInt('primaryColor')) == null) {
        selectedColor = Color(0xff5153FF);
      } else {
        selectedColor = Color(prefs.getInt('primaryColor'));
      }
    });
  }

  @override
  void initState() {
    openSharedPreferences();
    super.initState();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  Color pickedColor;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Text("设置",
                    style: TextStyle(
                        fontFamily: "Title",
                        fontSize: 28,
                        color: primaryColor))),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SetMasterPassword()));
            },
            child: ListTile(
              title: Text(
                "主密码",
                style: TextStyle(
                  fontFamily: 'Title',
                ),
              ),
              subtitle: Text(
                "修改主密码",
                style: TextStyle(
                  fontFamily: 'Subtitle',
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  "主题色",
                  style: TextStyle(
                    fontFamily: 'Title',
                  ),
                ),
                subtitle: Text(
                  "修改主题色",
                  style: TextStyle(
                    fontFamily: 'Subtitle',
                  ),
                ),
              ),
              MaterialColorPicker(
                onColorChange: (Color color) {
                  pickedColor = color;
                  changeColor(color);
                  setState(() {
                    selectedColor = color;
                  });
                },
                circleSize: 60,
                selectedColor: selectedColor,
                shrinkWrap: true,
              ),
            ],
          )
        ],
      ),
    );
  }

  void changeColor(Color color) {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('primaryColor', color.value);

    DynamicTheme.of(context).setThemeData(new ThemeData().copyWith(
      primaryColor: color,
    ));
  }
}
