import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

showAlertDialogUPdate(
  BuildContext context,
  String title,
  String message,
) {
  // set up the button

  // show the dialog
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: primaryColor),
          ),
          content: Text(message),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                LaunchReview.launch(
                    androidAppId: "lucky_live_football_tv.com",
                    iOSAppId: "585027354");
              },
              child: Text('Update'),
            ),
          ],
        ),
      );
    },
  );
}

/////////////////////////Advert///////////
///

////////INTERSTITIALADD////////////
///

/////////////////BANNER AD////////////

showBannerAdd({required double height, required double width}) {
  // InterstitialAd interstitialAd;
  // final BannerAd myBanner = BannerAd(
  //   adUnitId: 'ca-app-pub-4776928977402041/9399402742',
  //   size: AdSize(width: width.toInt(), height: height.toInt()),
  //   request: AdRequest(
  //       keywords: ["education", "school", "scholarship", "jobs", "edutech"]),
  //   listener: BannerAdListener(),
  // );

  // final AdWidget adWidget = AdWidget(ad: myBanner);
  // myBanner.load();
  if (settings.is_show_ads == true) {
    return Container(
        // alignment: Alignment.center,
        // child: adWidget,
        // width: myBanner.size.width.toDouble(),
        // height: myBanner.size.height.toDouble(),
        );
  }
  return Container(
      //child: Text("no Add"),
      );
}
