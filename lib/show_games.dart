import 'package:flutter/material.dart';
import 'package:live_footbal_tv/add_counter.dart';
import 'package:live_footbal_tv/constants.dart';
import 'package:live_footbal_tv/display_video.dart';
import 'package:live_footbal_tv/shima_preloader.dart';
import 'package:live_footbal_tv/widgets.dart';
import 'package:translator/translator.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:flutter_translate/flutter_translate.dart';

class ShowGames extends StatefulWidget {
  String category;
  ShowGames({Key? key, required this.category}) : super(key: key);

  @override
  State<ShowGames> createState() => _ShowGamesState();
}

class _ShowGamesState extends State<ShowGames> {
  bool isLoading = false;
  List<Map<dynamic, dynamic>> matchList = [];
  final translator = GoogleTranslator();

  Future extractData() async {
    matchList.clear();
    isLoading = true;
    setState(() {});
//Getting the response from the targeted url
    final response =
        await http.Client().get(Uri.parse('https://livehd77.live/m3/'));

    //Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      //Getting the html document from the response
      var document = parser.parse(response.body);

      try {
        var num = document
            .getElementById(widget.category)!
            .getElementsByClassName('albaflex')[0]
            .children
            .length;
        print("num");
        print(num);
        for (int i = 0; i < num; i++) {
          var targetTag = document
              .getElementById(widget.category)!
              .getElementsByClassName('albaflex')[0]
              .children[i];
          var awayTeam = targetTag
              .children[0].children[1].children[0].children[0].children[1].text
              .trim();
          //print(homeTeam);
          // var homeTeamLogo = targetTag.children[0].children[0].children[2]
          //     .children[0].children[0].attributes['src'];

          var homeTeam = targetTag
              .children[0].children[1].children[2].children[0].children[1].text
              .trim();

          var matchTime = targetTag.children[0].children[1].children[1]
              .children[0].children[1].children[1].text
              .trim();
          var awayScore = targetTag
              .children[0].children[1].children[1].children[0].children[0].text
              .trim();
          var homeScore = targetTag
              .children[0].children[1].children[1].children[0].children[2].text
              .trim();
          // print(awayScore + " : " + awayScore);
          // print("hh");
          // var awayTeamLogo = targetTag.children[0].children[0].children[0]
          //     .children[0].children[0].attributes['src'];
          var link = targetTag.children[0].attributes['href'];
          var match = {};
          match['scores'] = homeScore + " : " + awayScore;
          match['matchTime'] = "";
          match['link'] = link;
          translator.translate(matchTime).then((value) {
            var _matchHour = int.parse(value.text.substring(0, 1)) - 1;
            if (_matchHour == 0) {
              _matchHour = 12;
            }
            match['matchTime'] = _matchHour.toString() +
                value.text.substring(1, value.text.length);
            setState(() {});
          });
          translator.translate(homeTeam).then((value) {
            match['homeTeam'] = value.text;
            setState(() {});
          });
          translator.translate(awayTeam).then((value) {
            match['awayTeam'] = value.text;
            setState(() {});
          });
          match['homeTeam'] = homeTeam;
          match['awayTeam'] = awayTeam;
          match['homeTeamLogo'] = "kk";
          match['awayTeamLogo'] = "oo";
          matchList.add(match);
          // feed.add(link!);
          setState(() {});
        }
      } catch (e) {
        print(e);
        return ['', '', 'ERROR!'];
      }
    } else {
      print(response.statusCode);
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  void request() async {
    adCounter();
    // print(translation);
    await extractData();
  }

  @override
  void initState() {
    request();
    // TODO: implement initState
    super.initState();
  }

  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

          // if isLoading is true show loader
          // else show Column of Texts
          child: isLoading
              ? Center(
                  child: Container(
                      margin: EdgeInsets.only(top: 150), child: Shima()))
              : Container(
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: matchList.length,
                      itemBuilder: (c, i) {
                        var match = matchList[i];

                        ///print(i);
                        var home = match['homeTeam'];

                        if (count >= int.parse(settings.post_b4_ads!)) {
                          count = 0;
                          return Column(
                            children: [
                              showBannerAdd(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width),
                              SizedBox(
                                height: 20,
                              ),
                              singleMatch(match)
                            ],
                          );
                        }
                        count++;
                        return singleMatch(match);
                      }),
                )),
    );
  }

  Widget singleMatch(match) {
    return InkWell(
      onTap: () {
        adCounter();
        if (settings.show_video!) {
          var route = MaterialPageRoute(
              builder: (BuildContext b) => DisplayVideo(url: match['link']));
          Navigator.of(context).push(route);
        }
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.memory(
                    //     base64Decode(match['homeTeamLogo'])),
                    Text(
                      match['homeTeam'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
                Expanded(
                    child: Container(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(match['scores']),
                    settings.show_video!
                        ? Icon(
                            Icons.play_circle,
                            color: Colors.green,
                          )
                        : Container(),
                    Text(match['matchTime']),
                  ],
                ))),

                // Image.memory(
                //     base64Decode(match['awayTeamLogo'])),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      match['awayTeam'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
