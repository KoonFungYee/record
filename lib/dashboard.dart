import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:record/infoDB.dart';
import 'package:sqflite/sqflite.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  double _scaleFactor = 1.0;
  bool isSend, status;
  List<Map> offlineInfo;
  double font12 = ScreenUtil().setSp(27.6, allowFontScalingSelf: false);
  double font14 = ScreenUtil().setSp(32.2, allowFontScalingSelf: false);
  double font18 = ScreenUtil().setSp(41.4, allowFontScalingSelf: false);
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    status = isSend = false;
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
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
            centerTitle: true,
            title: Text(
              "Dashboard",
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
          child: (status == false)
              ? Container()
              : Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          BouncingWidget(
                            scaleFactor: _scaleFactor,
                            // onPressed: _checkIn,
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
                                color: (isSend == false)
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              child: Center(
                                child: Text(
                                  'Check In',
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
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(85),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.43,
                                      padding: EdgeInsets.all(
                                          ScreenUtil().setHeight(20)),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade800),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Date & Time",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: font14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      padding: EdgeInsets.all(
                                          ScreenUtil().setHeight(20)),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade800),
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade800),
                                          right: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade800),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "(°C)",
                                            style: TextStyle(
                                              // color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: font14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      padding: EdgeInsets.all(
                                          ScreenUtil().setHeight(20)),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade800),
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade800),
                                          right: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade800),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Status",
                                            style: TextStyle(
                                              // color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: font14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    for (int i = 0; i < offlineInfo.length; i++)
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setHeight(20)),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                                right: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  offlineInfo[i]['date'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: font12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setHeight(20)),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                                right: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  offlineInfo[i]['temp'],
                                                  style: TextStyle(
                                                    // color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: font12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setHeight(20)),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                                right: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade800),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  offlineInfo[i]['status'],
                                                  style: TextStyle(
                                                    color: _color(offlineInfo[i]
                                                        ['status']),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: font12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Color _color(String status) {
    Color color;
    if (status == 'normal') {
      color = Colors.green;
    } else if (status == 'normal') {
      color = Colors.yellow[700];
    } else {
      color = Colors.red;
    }
    return color;
  }

  Future<void> initialize() async {
    Database db = await InfoDB.instance.database;
    offlineInfo = await db.query(InfoDB.table);
    setState(() {
      status = true;
    });
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    return Future.value(false);
  }
}
