// FAVORI
// 5 Juillet

// On Va boucler sur la TAble MEMEID

//  On prend la Partie   gameecode    concernée

//MEMEID   | int         | NO   | PRI | NULL    | auto_increment |
//PHOTOID  | int         | NO   |     | NULL    |                |
//GAMECODE | int         | NO   | MUL | NULL    |                |
// UID      | int         | NO   |     | NULL    |                |
// MEMETEXT | varchar(50) | YES  |     | NULL    |                |
//listMemoLike[cestCeluiLa].photofilename +
//listMemoLike[cestCeluiLa].photofiletype,
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// Ici  On entre avec Un gamecode
class GameVote extends StatefulWidget {
  const GameVote({Key? key}) : super(key: key);

  @override
  State<GameVote> createState() => _GameVoteState();
}

class _GameVoteState extends State<GameVote> {
  String ipv4name = "**.**.**";

  bool readGameLikeState = false;
  int readGameLikeError = 0;
  int getGameVoteError = 0;
  List<GameLike> listGameLike = [];
  bool readGameVoteState = false;
  bool readGameVoteVoteState = false;

  bool readGameLikeVoteState = false;
  List<int> listCountEmo = [];
  List<CheckVotePlus> listCheckVote = [];

  List<GameByUser> myGames = [];

  int cestCeluiLa = 0;
  bool repaintPRL = true;

  bool booLike = false;
  bool feuOrange = true;
  Color colorCounter = Colors.green;
  final now = DateTime.now();

  double thatAverage = 0;
  late int myUid;

  //
  bool changeStatusGameUserState = false;
  bool getGamebyCodeState = false;
  int getGamebyCodeError = 0;
  List<Games> myGuGame = []; //  only one Games`
  //  Chrono
  bool chronoStart = false;
  Duration countdownDuration = const Duration(seconds: 10000);
  int timerVoteGame = 0;

  //Duration countdownDuration = Duration();
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;
  int totalSeconds = 0;
  bool timeOut = false;

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        timeOut = true;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;
    if (!feuOrange && getGamebyCodeState) buildTime();
    if (feuOrange && getGamebyCodeState) {
      setState(() {
        countDown = true;
        countdownDuration = Duration(seconds: timerVoteGame);
        duration = Duration(seconds: timerVoteGame);
        reset();

        startTimer();
        chronoStart = true;
        feuOrange = false;

        //
      });
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {
        //  changeStatusGameUser(8);
          cleanExit()
                      },

                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child: const Text('Save&Exit')),
                ElevatedButton(
                    onPressed: () => {null},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.green,
                            fontWeight: FontWeight.bold)),
                    child: Text(myPerso.myPseudo)),
                Text(PhlCommons.thisGameCode.toString()),
                Visibility(
                  visible: booLike,
                  child: IconButton(
                      icon: const Icon(Icons.sunny),
                      iconSize: 35,
                      color: Colors.yellowAccent,
                      tooltip: 'Not Like',
                      onPressed: () {
                        // createMemeSolo();
                      }),
                ),
                Visibility(
                  visible:
                      chronoStart && getGamebyCodeState && totalSeconds < 9900,
                  child: Text('->' + totalSeconds.toString() + 's',
                      style: TextStyle(
                          color:
                              (totalSeconds < 10) ? Colors.red : Colors.white,
                          fontSize: 18)),
                ),
                // Align(child: buildTime()),
              ],
            ),
          ),
        ]),
        body: readGameLikeState
            ? SafeArea(
                child: Column(children: <Widget>[
                  //Align(child: buildTime()),
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        listGameLike[cestCeluiLa].memetext,
                        style: GoogleFonts.averageSans(fontSize: 18.0),
                      )),
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                      "upload/" +
                          listGameLike[cestCeluiLa].photofilename +
                          "." +
                          listGameLike[cestCeluiLa].photofiletype,
                    ),
                  ),
                  readGameLikeVoteState || true
                      ? Row(
                          children: <Widget>[
                            //🤣
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 1)},
                                  child: const Text(
                                    '🙁',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 1)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 2)},
                                  child: const Text(
                                    '😐',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 2)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 3)},
                                  child: const Text(
                                    '🙂',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 3)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 4)},
                                  child: const Text(
                                    '😄',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 4)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 5)},
                                  child: const Text(
                                    '😆',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 5)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () => {pressEmoticone(myUid, 6)},
                                  child: const Text(
                                    '🤣',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                (listGameLike[cestCeluiLa].mynote == 6)
                                    ? const Text("1")
                                    : const Text("0"),
                              ],
                            )
                          ],
                        )
                      : const Text('...'),
                  Center(
                      child: Text(
                          'By ' + listGameLike[cestCeluiLa].uid.toString())),
                ]),
              )
            : const Text(''),
        bottomNavigationBar: Row(children: [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Prev',
              onPressed: () {
                prevPRL();
              }),
          Text(
            (cestCeluiLa + 1).toString() + '/' + listGameLike.length.toString(),
            style: GoogleFonts.averageSans(fontSize: 18.0),
          ),
          IconButton(
              icon: const Icon(Icons.arrow_forward),
              iconSize: 35,
              color: Colors.blue,
              tooltip: 'Next',
              onPressed: () {
                nextPRL();
              }),

        ]),
      ),
    );
  }

  buildTime() {
    setState(() {
      totalSeconds = duration.inSeconds;
      if (totalSeconds < 10) colorCounter = Colors.red;
    });
    if (totalSeconds <= 1) {
      stopTimer();
      changeStatusGameUser(4); //has Voted
      Navigator.pop(context);
    }
  }

  Future changeStatusGameUser(int _status) async {
    // STATUS ONLINE/OFFINE =BIT 1 on
    // 2 MEMING
    // 4 MEMECLOSED
    // 8  VOTING
    // 16 VOTECLOSED
    Uri url = Uri.parse(pathPHP + "changeStatusGameUser.php");
    changeStatusGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      // +1 CAr  si le GameUSer Vote cest donc quil est en ligne
      "GUSTATUS": (_status).toString(),
    };
    await http.post(url, body: data);
    changeStatusGameUserState = true;
  }

  Future createGameVote(int _myUid, int _points) async {
    Uri url = Uri.parse(pathPHP + "createGameVote.php");

    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "GVPOINTS": _points.toString(),
      "GVLAST": now.toString(),
      "MEMEID": listGameLike[cestCeluiLa].memeid.toString(),
      "UID": _myUid.toString()
    };
    var res = await http.post(url, body: data);
    //var datamysql = jsonDecode(res.body) as List;
    setState(() {});
  }

  Future createGameVoteAll(int _myUid) async {

    Uri url = Uri.parse(pathPHP + "createGameVoteAll.php");

    for (GameLike _thisVote in listGameLike) {
      var data = {
        "GAMECODE": PhlCommons.thisGameCode.toString(),
        "MLVPOINTS": _thisVote.mynote.toString(),
        "MLVDATE": now.toString(),
        "MEMOLIKEID": _thisVote.memeid.toString(),
        "UID": myUid.toString()
      };
      await http.post(url, body: data);
    }
  }

  Future getGamebyCode() async {
    int _thisGameCode = PhlCommons.thisGameCode;
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "getGAMEBYCODE.php");
    var data = {
      "GAMECODE": _thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGamebyCodeState = false;
      getGamebyCodeError = 1001;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGuGame = datamysql.map((xJson) => Games.fromJson(xJson)).toList();
        getGamebyCodeState = true;
        getGamebyCodeError = 0;
        // On le met à  la source
        timerVoteGame = myGuGame[0].gametimevote;

        countdownDuration = Duration(seconds: timerVoteGame);

      });
    } else {}
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();
    setState(() {
      ipv4name = ipv4;
    });
  }

  @override
  void initState() {
    super.initState();
    cestCeluiLa = 0;
    getIP();
    readGameLike(); // Seule Lecture

    getGamebyCode(); // H-eu
    changeStatusGameUser(3); //Voting

    listCountEmo.clear();
    for (int i = 0; i < 6; i++) {
      listCountEmo.add(0);
    }
    reset();

    setState(() {
      if (readGameLikeState) {
        if (readGameLikeVoteState) {
          repaintPRL = true;
        }
      }
    });

    Timer.periodic(Duration(seconds: 100), (timer) {
      print(DateTime.now());
    });
  }

  nextPRL() {
    setState(() {
      cestCeluiLa++;
      if (cestCeluiLa >= listGameLike.length) {
        cestCeluiLa = listGameLike.length - 1;
      }
      repaintPRL = true;
    });
  }

  pressEmoticone(int _myUid, int lequel) {
    setState(() {
      if (listGameLike[cestCeluiLa].mynote == lequel) {
        listGameLike[cestCeluiLa].mynote = 0;
      } else {
        listGameLike[cestCeluiLa].mynote = lequel;
      }
      createGameVote(_myUid, lequel);
      //nextPRL();
    });
  }

  prevPRL() {
    setState(() {
      cestCeluiLa--;
      if (cestCeluiLa < 0) cestCeluiLa = 0;
      repaintPRL = true;
    });
  }

  Future readGameLike() async {
    Uri url = Uri.parse(pathPHP + "readGAMELIKE.php");
    readGameLikeState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };

    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      readGameLikeError = 1001; //Not Found
    }
    if (response.statusCode == 200 && (readGameLikeError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        readGameLikeError = 0;
        listGameLike =
            datamysql.map((xJson) => GameLike.fromJson(xJson)).toList();
        readGameLikeState = true;
      });
    } else {}
  }

  Future readGameVote() async {
    Uri url = Uri.parse(pathPHP + "readGameVote.php");

    http.Response response = await http.post(url);
    if (response.body.toString() == 'ERR_1001') {}
    if (response.statusCode == 200 && (readGameLikeError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {});
    } else {}
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);

    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
  void cleanExit()
  {

    stopTimer();
    Navigator.pop(context);
  }
}
