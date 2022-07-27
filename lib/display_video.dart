import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//import 'package:html/dom.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
//import 'package:flutter_html/flutter_html.dart';

class DisplayVideo extends StatefulWidget {
  String url;
  DisplayVideo({required this.url});

  @override
  State<DisplayVideo> createState() => _DisplayVideoState();
}

class _DisplayVideoState extends State<DisplayVideo> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  bool isLoading = false;
  List<Map<dynamic, dynamic>> matchList = [];
  var mainUrl = "";
  var iframe;

  Future extractData2() async {
    matchList.clear();
    isLoading = true;
    setState(() {});
//Getting the response from the targeted url
    final response = await http.Client().get(Uri.parse(widget.url));

    //Status Code 200 means response has been received successfully

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      //Getting the html document from the response
      var document = parser.parse(response.body);

      try {
        var num = document.getElementsByTagName("iframe").length;

        print(num);
        iframe = document.getElementsByTagName("iframe")[0];

        // print(document.getElementsByTagName("iframe")[0].attributes['src']);
        mainUrl = document
            .getElementsByTagName("iframe")[0]
            .attributes['src']
            .toString();

        setState(() {});
        print(mainUrl);

        return;
      } catch (e) {
        print(e);
        return ['', '', 'ERROR!'];
      }
    } else {
      print(response.statusCode);
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ]);
    extractData2();
    // TODO: implement initState
    super.initState();
  }

  List<String> list = [];

  @override
  dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainUrl != ""
          ? GestureDetector(
              onVerticalDragUpdate: (updateDetails) {},
              child: Stack(
                children: [
                  WebView(
                    initialUrl: mainUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      //webViewController.scrollTo(0, 1800);
                      _completer.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      print('WebView is loading (progress : $progress%)');
                    },
                    javascriptChannels: <JavascriptChannel>{
                      //_toasterJavascriptChannel(context),
                    },
                    navigationDelegate: (NavigationRequest request) {
                      // print(mainUrl + "999999999999999999999999999999999999");
                      if (!request.url.startsWith(widget.url)) {
                        print('blocking navigation to $request}');
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      if (url.startsWith("https://youtube")) {
                        showAlertDialog(context);
                      }
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print(url);
                      print('Page finished loading: $url');
                    },
                    // gestureNavigationEnabled: true,
                    backgroundColor: Colors.black,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                  )
                ],
              ),
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("OK"));
    AlertDialog alertDialog = AlertDialog(
      title: Text("Alert!"),
      content: Text("This match might have not started"),
      actions: [okButton],
    );
    showDialog(
        context: context,
        builder: (ctx) {
          return alertDialog;
        });
  }

  // mard(){
  //   return InAppWebView(
  //             initialOptions: InAppWebViewGroupOptions(
  //               android: AndroidInAppWebViewOptions(
  //                 useShouldInterceptRequest: true,
  //               ),
  //             ),
  //             initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
  //             androidShouldInterceptRequest: (controller, request) async {
  //               var url = request.url.toString();
  //               var i = 0;
  //               while (i < list.length) {
  //                 if (url.contains(list.elementAt(i))) {
  //                   return WebResourceResponse();
  //                 }
  //                 i++;
  //               }
  //             });
  // }

}
