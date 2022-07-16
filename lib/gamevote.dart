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
  TextEditingController legendeController = TextEditingController();
  String mafoto = 'assets/oursmacron.png';
  bool myBool = false;
  String ipv4name = "**.**.**";
  String memeLegende = "";
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
  bool boolTexfield = true;
  bool booLike = false;

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
                                (listGameLike[cestCeluiLa].mynote == 1)?Text( "1") : Text ("0"),
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
                                (listGameLike[cestCeluiLa].mynote == 2)?Text( "1") : Text ("0"),
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
                                (listGameLike[cestCeluiLa].mynote == 3)?Text( "1") : Text ("0"),
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
                                (listGameLike[cestCeluiLa].mynote == 4)?Text( "1") : Text ("0"),
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
                                (listGameLike[cestCeluiLa].mynote == 5)?Text( "1") : Text ("0"),
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
                                (listGameLike[cestCeluiLa].mynote == 6)?Text( "1") : Text ("0"),
                              ],
                            )
                          ],
                        )
                      : Text('...'),
                  Center(
                      child: Text(
                          'By ' + listGameLike[cestCeluiLa].uid.toString())),
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
    var datamysql = jsonDecode(res.body) as List;
    setState(() {

    });


  }

  Future createGameVoteAll(int _myUid) async {
    //Uri url = Uri.parse(pathPHP + "createMLV.php");
    Uri url = Uri.parse(pathPHP + "createGameVoteAll.php");

    for (GameLike _thisVote in listGameLike) {
      var data = {
        "GAMECODE": PhlCommons.thisGameCode.toString(),
        "MLVPOINTS":  _thisVote.mynote.toString(),
        "MLVDATE": now.toString(),
        "MEMOLIKEID":  _thisVote.memeid.toString(),
        "UID": myUid.toString()
      };
        await http.post(url, body: data);
    }
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

    listCountEmo.clear();
    for (int i = 0; i < 6; i++) {
      listCountEmo.add(0);
    }

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
       if ( listGameLike[cestCeluiLa].mynote==lequel)  listGameLike[cestCeluiLa].mynote=0;
       else listGameLike[cestCeluiLa].mynote=lequel;
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

    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString()
    };

    http.Response response = await http.post(url);
    if (response.body.toString() == 'ERR_1001') {}
    if (response.statusCode == 200 && (readGameLikeError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {

      });
    } else {}
  }
}
