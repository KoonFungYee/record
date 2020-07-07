import 'dart:io';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menu_button/menu_button.dart';
import 'package:record/dashboard.dart';
import 'package:record/infoDB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double _scaleFactor = 1.0;
  double font14 = ScreenUtil().setSp(32.2, allowFontScalingSelf: false);
  double font18 = ScreenUtil().setSp(41.4, allowFontScalingSelf: false);
  final ScrollController controller = ScrollController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _passportcontroller = TextEditingController();
  final TextEditingController _tempcontroller = TextEditingController();
  var _iccontroller = new MaskedTextController(mask: '000000-00-0000');
  var _phonecontroller = new MaskedTextController(mask: '000-00000000');
  List<String> genderList = ["Male", "Female"];
  String gender, dateTime;
  bool isSend, isForeign;
  File pickedImage;
  List<String> icDetails = [];

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    dateTime = DateTime.now()
        .toString()
        .substring(0, DateTime.now().toString().length - 7);
    isForeign = isSend = false;
    gender = "Male";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    final Widget button = SizedBox(
      width: MediaQuery.of(context).size.width * 0.94,
      height: ScreenUtil().setHeight(60),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                gender,
                style: TextStyle(fontSize: font14),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(50),
              height: ScreenUtil().setWidth(50),
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            ScreenUtil().setHeight(85),
          ),
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              color: Colors.grey,
              icon: Icon(
                Icons.arrow_back_ios,
                size: ScreenUtil().setWidth(30),
              ),
              onPressed: _onBackPressAppBar,
            ),
            centerTitle: true,
            title: Text(
              "One-Time Sign In",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: font18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          controller: controller,
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                        onTap: _scan,
                        child: Text("Go fast with scan IC",
                            style: TextStyle(
                                fontSize: font14, color: Colors.blue))),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                InkWell(
                  onTap: _scan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(200),
                        width: ScreenUtil().setWidth(400),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/images/ic.jpg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Sample IC", style: TextStyle(fontSize: font14)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Name as per IC/Passport:",
                        style: TextStyle(fontSize: font14)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _namecontroller,
                          style: TextStyle(
                            height: 1,
                            fontSize: font14,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "eg. Yee Qi Huat",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isForeign = false;
                        });
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "IC Number",
                            style: TextStyle(
                                fontSize: font14,
                                color:
                                    (isForeign) ? Colors.blue : Colors.black),
                          ),
                        ]),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: " / ",
                            style: TextStyle(
                                fontSize: font14, color: Colors.black))
                      ]),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isForeign = true;
                        });
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Passport Number:",
                              style: TextStyle(
                                  fontSize: font14,
                                  color:
                                      (isForeign) ? Colors.black : Colors.blue))
                        ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                (isForeign == false)
                    ? Container(
                        height: ScreenUtil().setHeight(60),
                        padding: EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.grey.shade400,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _iccontroller,
                                style: TextStyle(
                                  height: 1,
                                  fontSize: font14,
                                ),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.go,
                                onSubmitted: (value) => _checkGender(value),
                                decoration: InputDecoration(
                                  hintText: "eg. 870123-14-5505",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: ScreenUtil().setHeight(10),
                                      bottom: ScreenUtil().setHeight(20),
                                      top: ScreenUtil().setHeight(-15),
                                      right: ScreenUtil().setHeight(20)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: ScreenUtil().setHeight(60),
                        padding: EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.grey.shade400,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _passportcontroller,
                                style: TextStyle(
                                  height: 1,
                                  fontSize: font14,
                                ),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: ScreenUtil().setHeight(10),
                                      bottom: ScreenUtil().setHeight(20),
                                      top: ScreenUtil().setHeight(-15),
                                      right: ScreenUtil().setHeight(20)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Phone Number:", style: TextStyle(fontSize: font14)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _phonecontroller,
                          style: TextStyle(
                            height: 1,
                            fontSize: font14,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "eg. 010-1234567",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Gender:", style: TextStyle(fontSize: font14)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                MenuButton(
                  child: button,
                  items: genderList,
                  scrollPhysics: AlwaysScrollableScrollPhysics(),
                  topDivider: true,
                  itemBuilder: (value) => Container(
                    height: ScreenUtil().setHeight(60),
                    width: MediaQuery.of(context).size.width * 0.94,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 10),
                    child: Text(value, style: TextStyle(fontSize: font14)),
                  ),
                  toggledChild: Container(
                    color: Colors.white,
                    child: button,
                  ),
                  divider: Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  onItemSelected: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(3.0)),
                      color: Colors.white),
                  onMenuButtonToggle: (isToggle) {},
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Temperature(°C):",
                        style: TextStyle(fontSize: font14)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _tempcontroller,
                          style: TextStyle(
                            height: 1,
                            fontSize: font14,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(20),
                                top: ScreenUtil().setHeight(-15),
                                right: ScreenUtil().setHeight(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Time:", style: TextStyle(fontSize: font14)),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.only(left: ScreenUtil().setHeight(10)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.grey.shade400, style: BorderStyle.solid),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(dateTime),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BouncingWidget(
                      scaleFactor: _scaleFactor,
                      onPressed: _signIn,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: ScreenUtil().setHeight(80),
                        margin: EdgeInsets.fromLTRB(
                            0,
                            ScreenUtil().setHeight(10),
                            ScreenUtil().setHeight(10),
                            ScreenUtil().setHeight(10)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: (isSend == false) ? Colors.blue : Colors.grey,
                        ),
                        child: Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: font14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _namecontroller.text);
    if (isForeign == false) {
      prefs.setString('ic', _iccontroller.text);
    } else {
      prefs.setString('ic', _passportcontroller.text);
    }
    prefs.setString('phone', _phonecontroller.text);
    prefs.setString('gender', gender);
    double temp = double.parse(_tempcontroller.text);
    String status;
    if (temp < 37) {
      status = "normal";
    } else if (temp >= 37) {
      status = "caution";
    } else if (temp >= 37.5) {
      status = "dangerous";
    }
    Database db = await InfoDB.instance.database;
    await db.rawInsert('INSERT INTO info (date, temp, status) VALUES("' +
        dateTime +
        '","' +
        _tempcontroller.text +
        '","' +
        status +
        '")');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashBoard()));
  }

  Future<void> _scan() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    if (tempStore != null) {
      setState(() {
        pickedImage = tempStore;
      });
      readText();
    }
  }

  Future readText() async {
    icDetails.clear();
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    String patttern = r'[0-9]';
    String number;
    RegExp regExp = new RegExp(patttern);
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        String temPhone = "";
        for (int i = 0; i < line.text.length; i++) {
          if (regExp.hasMatch(line.text[i])) {
            temPhone = temPhone + line.text[i];
          }
        }
        if (temPhone.length >= 8) {
          number = line.text;
        }
        icDetails.add(line.text);
      }
    }
    setState(() {
      _namecontroller.text = icDetails[4];
      _iccontroller.text = number;
    });
  }

  void _checkGender(String number) {
    try {
      int last = int.parse(number.substring(number.length - 1));
      if (last % 2 == 0) {
        gender = "Female";
      } else {
        gender = "Male";
      }
    } catch (e) {}
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.of(context).pop();
    return Future.value(false);
  }
}
