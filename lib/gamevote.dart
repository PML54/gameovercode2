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

class GameVote extends StatefulWidget {
  const GameVote({Key? key}) : super(key: key);

  @override
  State<GameVote> createState() => _GameVoteState();
}

class _GameVoteState extends State<GameVote> {
  TextEditingController legendeController = TextEditingController();
  String mafoto = 'assets/oursmacron.png';
  bool myBool = false;
  String ipv4name = "**.**.**";
  String memeLegende = "";
  bool readGameLikeState=false;
  int readGameLikeError =0;
  int getGameVoteError = 0;
  List<GameLike> listGameLike = [];
  bool readGameVoteState = false;
  bool readGameVoteVoteState = false;
  bool listCheckMlvuState = false;
 bool     readGameLikeVoteState  = false;
  List<int> listCountEmo = [];
  List<CheckVotePlus> listCheckVote = [];
  List<CheckMLVU> listCheckMlvu = [];
  List<GameByUser> myGames = [];
  int cecodegame=   PhlCommons.thisGameCode;
  int cestCeluiLa = 0;
  bool repaintPRL = true;
  bool boolTexfield = true;
  bool booLike = false;
  bool getGamebyUidState = true;
  int getGamebyUidError = 0;
  final now = DateTime.now();
  int thatSum = 0;
  int thatCount = 0;
  double thatAverage = 0;
  late int myUid;

  @override
  Widget build(BuildContext context) {
    final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    myUid = myPerso.myUid;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {Navigator.pop(context)},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.red,
                            fontWeight: FontWeight.bold)),
                    child: const Text('Exit')),
                Text(
                  myPerso.myPseudo + " ",
                  style: GoogleFonts.averageSans(fontSize: 18.0),
                ),
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
                Slider(
                    label: '% Like ',
                    activeColor: Colors.red,
                    divisions: 20,
                    min: 0,
                    max: 50,
                    value: thatAverage.toDouble(),
                    onChanged: (double newValue) {}),
              ],
            ),
          ),
        ]),

        //body: readMemolikeVoteState
        body: readGameLikeState
            ? SafeArea(
          child: Column(children: <Widget>[
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
            readGameLikeVoteState
                ? Row(
              children: <Widget>[
                //🤣
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {pressEmoticone(myUid, 0)},
                      child: const Text(
                        '🙁',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text((listCountEmo[0]).toString())
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {pressEmoticone(myUid, 1)},
                      child: const Text(
                        '😐',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text((listCountEmo[1]).toString())
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {pressEmoticone(myUid, 2)},
                      child: const Text(
                        '🙂',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text((listCountEmo[2]).toString())
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {pressEmoticone(myUid, 3)},
                      child: const Text(
                        '😄',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text((listCountEmo[3]).toString())
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {pressEmoticone(myUid, 4)},
                      child: const Text(
                        '😆',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text((listCountEmo[4]).toString())
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () => {pressEmoticone(myUid, 5)},
                      child: const Text(
                        '🤣',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Text((listCountEmo[5]).toString())
                  ],
                )
              ],
            )
                : Text('...'),
            Center(
                child:
                Text('By ' + listGameLike[cestCeluiLa].uid.toString())),
          ]),
        )
            : Text(''),
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
          Text(
            " Moyenne = " + thatAverage.toString(),
            style: GoogleFonts.averageSans(fontSize: 15.0),
          ),
        ]),
      ),
    );
  }
  Future createMemolikeVote(int _myUid, int _points) async {
    Uri url = Uri.parse(pathPHP + "createMLV.php");
    var data = {
      "MLVPOINTS": _points.toString(),
      "MLVDATE": now.toString(),
      "MEMOLIKEID": listGameLike[cestCeluiLa].memeid.toString(),
      "UID": _myUid.toString()
    };
    var res = await http.post(url, body: data);
    var datamysql = jsonDecode(res.body) as List;
    setState(() {
      getMLVU();
      listCheckVote =
          datamysql.map((xJson) => CheckVotePlus.fromJson(xJson)).toList();
      updateThisMli(listGameLike[cestCeluiLa].memeid);
      thatAverage =
          (updateThisMli(listGameLike[cestCeluiLa].memeid)).toDouble();
    });
  }
  Future getIP() async {
    final ipv4 = await Ipify.ipv4();
    setState(() {
      ipv4name = ipv4;
    });
  }
  Future getMLVU() async {
    Uri url = Uri.parse(pathPHP + "getMLVU.php");
    listCheckMlvuState = false;

    http.Response response = await http.post(url);
    if (response.body.toString() == 'ERR_1001') {}
    if (response.statusCode == 200 && (readGameLikeError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listCheckMlvu =
            datamysql.map((xJson) => CheckMLVU.fromJson(xJson)).toList();
        listCheckMlvuState = true;
      });
    } else {}
  }
  @override
  void initState() {
    super.initState();
    cestCeluiLa = 0;
    getIP();

    getGamebyUid();


    listCountEmo.clear();
    for (int i = 0; i < 6; i++) {
      listCountEmo.add(0);
    }

    setState(() {
      if (readGameLikeState) {
        if (readGameLikeVoteState) {
      updateThisMli(listGameLike[cestCeluiLa].memeid);
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
      thatSum = 0;
      thatCount = 0;
      booLike = false;
      cestCeluiLa++;
      if (cestCeluiLa >= listGameLike.length) {
        cestCeluiLa = listGameLike.length - 1;
      }

      readGameLikeVote();
      repaintPRL = true;
      updateThisMli(listGameLike[cestCeluiLa].memeid);
    });
  }
  pressEmoticone(int _myUid, int lequel) {
    setState(() {
      createMemolikeVote(_myUid, lequel);
    });
  }
  prevPRL() {
    setState(() {
      thatSum = 0;
      thatCount = 0;
      booLike = false;
      cestCeluiLa--;
      if (cestCeluiLa < 0) cestCeluiLa = 0;

      readGameLikeVote();
      repaintPRL = true;
      updateThisMli(listGameLike[cestCeluiLa].memeid);
    });
  }
  Future readGameLike() async {
    Uri url = Uri.parse(pathPHP + "readGAMELIKE.php");
    readGameLikeState = false;
    var data = {
      "GAMECODE":  PhlCommons.thisGameCode.toString(),
    };

    http.Response response  = await http.post(url, body: data);
     if (response.body.toString() == 'ERR_1001') {
      readGameLikeError = 1001; //Not Found
      print ('Dans readGameLike 1001');
    }
    if (response.statusCode == 200 && (readGameLikeError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        readGameLikeError = 0;
      listGameLike =
            datamysql.map((xJson) => GameLike.fromJson(xJson)).toList();
        readGameLikeState = true;

        print ("listGameLike"+listGameLike.length.toString());
      //   readGameLikeVote();
      });
    } else {}
  }
  Future  readGameLikeVote() async {
    Uri url = Uri.parse(pathPHP + "getMLV.php");
    readGameLikeVoteState  = false;
    var data = {
      "MEMOLIKEID": listGameLike[cestCeluiLa].memeid.toString(),
    };

    var res = await http.post(url, body: data);
    var datamysql = jsonDecode(res.body) as List;
    setState(() {
      listCheckVote =
          datamysql.map((xJson) => CheckVotePlus.fromJson(xJson)).toList();
      readGameLikeVoteState = true;

      thatAverage =
          (updateThisMli(listGameLike[cestCeluiLa].memeid)).toDouble();
    });
  }
  int updateThisMli(int _memolikeid) {
    // Repartion  des Like
    int _thatNote = 0;
    int inote = 0;
    listCountEmo.clear();
    for (int i = 0; i < 6; i++) {
      listCountEmo.add(0);
    }
    for (CheckVotePlus _cvp in listCheckVote) {
      if (_cvp.memolikeid == _memolikeid) {
        int suiCi = _cvp.mlvpoints;
        _thatNote = _thatNote + suiCi;
        inote++;
        listCountEmo[suiCi] = _cvp.cumu;
      }
    }
    if (inote == 0) inote = 1;
    int calcul = _thatNote * 10 ~/ inote;
    return (calcul);
  }

  Future getGamebyUid() async {
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "getGAMEBYUID.php");

    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGamebyUidState = false;
      getGamebyUidError = 1001;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGames = datamysql.map((xJson) => GameByUser.fromJson(xJson)).toList();

        PhlCommons.thisGameCode = myGames.last.gamecode;
        getGamebyUidState = true;
        getGamebyUidError = 0;
// tout est vert on Y va
        readGameLike(); // Seule Lecture



      });
    } else {}
  }
}
