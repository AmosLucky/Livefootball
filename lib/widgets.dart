import 'package:google_mobile_ads/google_mobile_ads.dart';

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
final BannerAdListener listener = BannerAdListener(
  // Called when an ad is successfully received.
  onAdLoaded: (Ad ad) => print('Ad loaded.'),
  // Called when an ad request failed.
  onAdFailedToLoad: (Ad ad, LoadAdError error) {
    // Dispose the ad here to free resources.
    ad.dispose();
    print('Ad failed to load: $error');
  },
  // Called when an ad opens an overlay that covers the screen.
  onAdOpened: (Ad ad) => print('Ad opened.'),
  // Called when an ad removes an overlay that covers the screen.
  onAdClosed: (Ad ad) => print('Ad closed.'),
  // Called when an impression occurs on the ad.
  onAdImpression: (Ad ad) => print('Ad impression.'),
);
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
