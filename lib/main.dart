import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:launch_review/launch_review.dart';
import 'package:live_footbal_tv/constants.dart';
import 'package:live_footbal_tv/settings.dart';
import 'package:live_footbal_tv/show_games.dart';
import 'package:http/http.dart' as http;
import 'package:live_footbal_tv/widgets.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lucky Live Football Stream',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  var deviveId = "";
  var controler;
  var animation;
  void post(deviceInfo) async {
    var request = await http.post(
        Uri.parse("http://livefootball.unlimitedsub.com/admin/index.php"),
        body: {
          "deviceId": deviceInfo[1],
          "deviceName": deviceInfo[0],
        });
    if (request.statusCode == 200) {
      var response = jsonDecode(request.body);
      print(response);
      settings = new Settings(
          version: response['version'],
          clicks_b4_ads: response['clicks_b4_ads'],
          post_b4_ads: response['post_b4_ads'],
          is_show_ads: response['is_show_ads'],
          show_video: response['show_video']);

      goToHome();
    } else {
      Scaffold.of(context).showBottomSheet((context) => InkWell(
              child: Row(
            children: [
              Expanded(child: Text("Please connect to the internet and retry")),
              Expanded(
                  child: TextButton(
                child: Text("Retry"),
                onPressed: () {
                  post(deviceInfo);
                },
              ))
            ],
          )));
    }
  }

  goToHome() {
    if (version >= int.parse(settings.version!)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext c) => TabViewClass()));
    } else {
      print(int.parse(settings.version!));
      showAlertDialogUPdate(context, "New Version Available",
          "We  have published a better version of this app please update your app to enjoy new features and better services from us ");
    }
  }

  Future<List<String>> getDeviceDetails() async {
    String deviceName = "";
    String deviceVersion = "";
    String identifier = "";
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model!;
        deviceVersion = build.version.toString();
        identifier = build.androidId!; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name!;
        deviceVersion = data.systemVersion!;
        identifier = data.identifierForVendor!; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    print(deviceName + " " + deviceVersion + " " + identifier);
    post([deviceName, identifier]);

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  var _deviceId = "";

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId!;
      print("deviceId->$_deviceId");
    });
  }

  @override
  void initState() {
    getDeviceDetails();
    controler =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(controler);
    controler.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controler.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
                scale: animation, child: Image.asset("images/logo.png"))
          ],
        ),
      ),
    );
  }
}

class TabViewClass extends StatefulWidget {
  const TabViewClass({Key? key}) : super(key: key);

  @override
  State<TabViewClass> createState() => _TabViewClassState();
}

class _TabViewClassState extends State<TabViewClass> {
  Future<bool> returnt() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => returnt(),
      child: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
            floatingActionButton: SpeedDial(
              overlayColor: Colors.transparent,
              overlayOpacity: 0.05,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.share, color: Colors.pinkAccent),
                    label: "Share App",
                    onTap: () {
                      // sharePosts(content) async {
                      Share.share(
                          " 😱 Hi friend, Install Live Football Stream Tv App and enjoy all Football matches free on your mobile in your comfort zone  😱😱 \n 👇👇👇 Click on the link \n" +
                              "https://play.google.com/store/apps/details?id=lucky_live_football_tv.com");
                      // final FlutterShareMe flutterShareMe = FlutterShareMe();
                      // var response = await flutterShareMe.shareToSystem(msg: msg);
                      // }
                    }),
                SpeedDialChild(
                    child: Icon(Icons.mail, color: Colors.pinkAccent),
                    label: "Contact Us",
                    onTap: () {
                      _launchInBrowser("mailto:luckylivefootballtv@gmail.com");
                    }),
                SpeedDialChild(
                    child: Icon(
                      Icons.star,
                      color: Colors.pinkAccent,
                    ),
                    label: "Rate Us",
                    onTap: () {
                      LaunchReview.launch(
                          androidAppId: "lucky_live_football_tv.com",
                          iOSAppId: "585027354");
                    })
              ],
            ),
            appBar: AppBar(
              leading: Container(),
              title: Text("Live Football Tv"),
              bottom: TabBar(
                tabs: [
                  Tab(
                    //icon: Icon(Icons.home),
                    text: "Yesterday",
                  ),
                  Tab(
                    //icon: Icon(Icons.favorite),
                    text: "Today",
                  ),
                  Tab(
                    // icon: Icon(Icons.person),
                    text: "Tomorrow",
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ShowGames(
                  category: "yestrday",
                ),
                ShowGames(
                  category: "today",
                ),
                ShowGames(
                  category: "tommorw",
                ),
              ],
            )),
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
