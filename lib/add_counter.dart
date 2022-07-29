import 'package:flutter/cupertino.dart';
import 'package:live_footbal_tv/constants.dart';
import 'package:startapp/startapp.dart';

var _interstitialAd;
var _isInterstitialAdReady = false;

int add_count = 0;
void adCounter() async {
  // await StartApp.showInterstitialAd();

  if (add_count >= int.parse(settings.clicks_b4_ads!)) {
    add_count = 0;

    if (settings.is_show_ads!) {
      await StartApp.showInterstitialAd();
      // loadInterstitialAd();
    }

    ///showMessage(context, "Ads", "Ads", 1);
    //print("add cont");
  } else {
    add_count++;
    //print(add_count);
  }
}

// void loadInterstitialAd() {
//   InterstitialAd.load(
//     adUnitId: 'ca-app-pub-4776928977402041/1120585330',
//     request: AdRequest(
//         keywords: ["education", "school", "scholarship", "jobs", "edutech"]),
//     adLoadCallback: InterstitialAdLoadCallback(
//       onAdLoaded: (ad) {
//         _interstitialAd = ad;

//         ad.fullScreenContentCallback = FullScreenContentCallback(
//           onAdDismissedFullScreenContent: (ad) {
//             //Navigator.pop(context);
//           },
//         );

//         _isInterstitialAdReady = true;
//       },
//       onAdFailedToLoad: (err) {
//         print('Failed to load an interstitial ad: ${err.message}');
//         _isInterstitialAdReady = false;
//       },
//     ),
//   );
//   if (settings.is_show_ads!) {
//     _interstitialAd?.show();
//   }
// }
