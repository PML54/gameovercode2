import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gamephlplusclass.dart';
import 'package:gameover/gameuser.dart';
import 'package:gameover/gamevote.dart';
import 'package:gameover/gamevoteresult.dart';
import 'package:gameover/phlcommons.dart';
import 'package:gameover/selectgamers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// A ce niveau On PAsse le Geme Users  à OFFLINE pour tous les Game

// Central Game
// On va lire les Record Audika  Poufr
// determiner ce ui'il est Juficieux de Lire
class GameSupervisor extends StatefulWidget {
  const GameSupervisor({Key? key}) : super(key: key);

  @override
  State<GameSupervisor> createState() => _GameSupervisorState();
}

class _GameSupervisorState extends State<GameSupervisor> {
  GameCommons myPerso = GameCommons("xxxx", 0, 0);
  GameAudika myAudikaGMU = GameAudika(
      audikaid: 0,
      codid: 1,
      lastid: 0,
      gamecode: 0,
      lastdate: DateTime.now().toString());
  GameAudika myAudikaGAME = GameAudika(
      audikaid: 0,
      codid: 2,
      lastid: 0,
      gamecode: 0,
      lastdate: DateTime.now().toString());
  bool ActionAudikaGMU = false; // Si true Relire Les GAMEUSERS
  bool ActionAudikaGAME = false; // Si true Relire les GAMes

  bool setGuOffGamesState = false;
  bool getGameUsersByCodeState = false;
  int getGameUsersByCodeError = 0;
  List<GameUsers> Gamers = [];
  bool promoteGameState = false;
  bool isGmid = false;
  bool changeStateGameUserState = false;

  bool checkAudikaState = false;
  int checkAudikaError = 0;
  List<GameAudika> listAudika = [];

  bool plusGamebyUidState = false;
  List<GamesPlus> myGamesStatus = [];

  bool getGamePhotoSelectState = false;
  int getGamePhotoSelectError = -1;
  List<PhotoBase> listPhotoBase = [];
  bool getGamebyUidState = false;
  int getGamebyUidError = 0;
  List<GameByUser> myGames = [];
  String thatPseudo = PhlCommons.thatPseudo;
  int cestCeluiLa = 0;
  int thatGamer = 0;

  int takeThisGameCode = 0;
  String greeting = "";
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: <Widget>[
          Expanded(
            child: Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: const TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.red,
                            fontWeight: FontWeight.bold)),
                    child: Text(' Exit GAME '),
                    onPressed: () {
                      changeStateGameUser(0);

                      Navigator.pop(context);
                    }),
                /*  IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.red,
                iconSize: 30.0,
                tooltip: 'Home',
                onPressed: () {
                  _timer?.cancel();

                  PhlCommons.thisGameCode = takeThisGameCode;
                  Navigator.pop(context);
                },
              ),*/
                Visibility(
                  visible: true,
                  child: ElevatedButton(
                    child: Text(
                      statusGame[PhlCommons.gameStatus],
                      style: GoogleFonts.averageSans(fontSize: 16.0),
                    ),
                    onPressed: () {
                      if (isGmid) promoteGame();
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () => {null},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        textStyle: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.green,
                            fontWeight: FontWeight.bold)),
                    child: Text(myPerso.myPseudo)),
                //Text(greeting), <PML>
              ],
            ),
          ),
        ]),
        body: SafeArea(
          child: Row(children: <Widget>[
            getListGame(),
            Visibility(
                visible: takeThisGameCode > 0, child: getListGameUsers()),
            getListView()
          ]),
        ),
        bottomNavigationBar: Row(
          //   visible: takeThisGameCode > 0,
          children: [
            Visibility(
              visible: PhlCommons.gameStatus == 1,
              child: ElevatedButton(
                child: Text(
                  " Commentez ",
                  style: GoogleFonts.averageSans(fontSize: 16.0),
                ),
                onPressed: () {
                  PhlCommons.thisGameCode = takeThisGameCode;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameUser(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: PhlCommons.gameStatus == 3,
              child: ElevatedButton(
                child: Text(
                  " Votez ",
                  style: GoogleFonts.averageSans(fontSize: 16.0),
                ),
                onPressed: () {
                  PhlCommons.thisGameCode = takeThisGameCode;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameVote(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: PhlCommons.gameStatus == 5,
              child: ElevatedButton(
                child: Text(
                  " Resutats ",
                  style: GoogleFonts.averageSans(fontSize: 16.0),
                ),
                onPressed: () {
                  PhlCommons.thisGameCode = takeThisGameCode;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameVoteResult(),
                      settings: RouteSettings(
                        arguments: myPerso,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future changeStateGameUser(int _state) async {
    Uri url = Uri.parse(pathPHP + "changeStateGameUser.php");

    if (PhlCommons.thisGameCode == 0) {
      return;
    }
    // <PML> cause insta in display
    //    changeStateGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATE": _state.toString(),
    };
    await http.post(url, body: data);
    changeStateGameUserState = true;
    //getGamebyUid();  // On l-relit les Games
  }

  Future checkAudika() async {
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "checkAUDIKA.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      checkAudikaState = false;
      checkAudikaError = 1001;
    } else {
      gameCodeFound = true;
    }
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;

      listAudika =
          datamysql.map((xJson) => GameAudika.fromJson(xJson)).toList();

      checkAudikaState = true;
      checkAudikaError = 0;

      // this Level compare with Reference
      print("listAudika[0].lastid" + listAudika[0].lastid.toString());

      if (listAudika[0].lastid != myAudikaGMU.lastid) {
        print("listAudika[0].lastid" + listAudika[0].lastid.toString());
      }
    } else {}
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

    print(" In getGamebyUid");
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGames = datamysql.map((xJson) => GameByUser.fromJson(xJson)).toList();
        PhlCommons.thisGameCode = myGames.last.gamecode; // ON prend le dernier
      });
      print(" Out getGamebyUid");
      getGamebyUidState = true;
      getGamebyUidError = 0;
    } else {}
  }

  Future getGamePhotoSelect() async {
    getGamePhotoSelectState = false;
    getGamePhotoSelectError = -1;
    Uri url = Uri.parse(pathPHP + "getGAMEPHOTOS.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
    };

    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPhotoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();
      });

      getGamePhotoSelectState = true;
      getGamePhotoSelectError = 0;
    } else {
      getGamePhotoSelectError = 2001;
    }
  }

  Future getGameUsersByCode() async {
    int _thisGameCode = PhlCommons.thisGameCode;
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP + "readGAMEUSERSBYCODE.php");
    var data = {
      "GAMECODE": _thisGameCode.toString(),
    };
    getGameUsersByCodeState = false;

    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameCodeFound = false;
      getGameUsersByCodeState = false;
      getGameUsersByCodeError = 0;
    } else {
      gameCodeFound = true;
    }

    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        Gamers = datamysql.map((xJson) => GameUsers.fromJson(xJson)).toList();
      });
      getGameUsersByCodeState = true;
      getGameUsersByCodeError = 0;
      // Trouvons le Gamer
      int jj = 0;
      for (GameUsers _brocky in Gamers) {
        if (_brocky.uid == PhlCommons.thatUid) {
          PhlCommons.thatStatus = _brocky.gustatus;
          PhlCommons.thatState = _brocky.gustate;
          thatGamer = jj;
        }
        jj++;
      }
      //
    } else {}
  }

  Expanded getListGame() {
    // getGamebyUid();
    if (!getGamebyUidState) {
      return (const Expanded(child: Text(".............")));
    }
    var listView = ListView.builder(
        itemCount: myGames.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            color: myGames[index].extraColor,
                            border: Border.all()),
                        child: Column(
                          children: [
                            Text(myGames[index].gamecode.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))
                          ],
                        )),
                  ),
                  Visibility(
                    visible: (myGames[index].gamestatus % 2 == 1),
                    child: IconButton(
                        //   icon: const Icon(Icons.favorite_rounded),
                        icon: const Icon(Icons.directions_run_outlined),
                        /*     showSimpleNotification(
                    Text("this is a message from simple notification"),
                    background: Colors.green);*/
                        iconSize: 25,
                        color: Colors.green,
                        tooltip: 'Resultats',
                        onPressed: () {
                          quelleAction(myGames[index].gamestatus);
                        }),
                  ), //  REsu
                ],
              ),
              onTap: () {
                setState(() {
                  myGames[index].isSelected = !myGames[index].isSelected;

                  if (myGames[index].isSelected) {
                    getGameUsersByCode();
                    //
                    isGmid = false;
                    isGmid = (PhlCommons.thatUid == myGames[index].gmid);
                    getGamePhotoSelectState = false;
                    cestCeluiLa = index;
                    getGamePhotoSelect();
                    takeThisGameCode = myGames[index].gamecode;

                    PhlCommons.thisGameCode = takeThisGameCode;
                    PhlCommons.gameStatus = myGames[index].gamestatus;
                    changeStateGameUser(1); // <PML>  pas sur
                    myPerso.myGame = takeThisGameCode;
                    myGames[index].extraColor = Colors.green;
                    int jj = 0;
                    for (GameByUser _brocky in myGames) {
                      if (jj++ != index) {
                        _brocky.isSelected = false;
                        _brocky.extraColor = Colors.grey;
                      }
                    }
                  } else {
                    myGames[index].extraColor = Colors.grey;
                    if (PhlCommons.thisGameCode > 0)
                      changeStateGameUser(0); // on cancel le dernier
                    PhlCommons.thisGameCode = 0;
                  }
                });
              });
        });
    return (Expanded(child: listView));
  }

  Expanded getListGameUsers() {
/*
    if (getGameUsersByCodeState) {

    return (const Expanded(child: Text(".............")));
    }*/
    var listView = ListView.builder(
        itemCount: Gamers.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: (Gamers[index].gustate == 1)
                                  ? Colors.green
                                  : Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  backgroundColor: (Gamers[index].gustate == 1)
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold)),
                          child: Text(
                              Gamers[index].uname +
                                  " " +
                                  Gamers[index].gustatus.toString(),
                              style: TextStyle(
                                  color: (Gamers[index].gustate == 1)
                                      ? Colors.black
                                      : Colors.black,
                                  fontSize:
                                      (Gamers[index].gustate == 1) ? 14 : 14)),
                          onPressed: () {
                            print("Gamers[index].gustate" +
                                Gamers[index].gustate.toString());
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isGmid && false,
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        iconSize: 20.0,
                        tooltip: 'Home',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  Expanded getListView() {
    if (!getGamePhotoSelectState) {
      return (const Expanded(child: Text(".............")));
    }
    var listView = ListView.builder(
        itemCount: listPhotoBase.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Image.network(
                        "upload/" +
                            listPhotoBase[index].photofilename +
                            "." +
                            listPhotoBase[index].photofiletype,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  @override
  void initState() {
    super.initState();
    checkAudika();
    getGamebyUid();
    SetGuOffGames();
    plusGamebyUid(); // <PML> on laisse ici ?
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        greeting = "Check ${DateTime.now().second}";
        checkAudika();
        getGameUsersByCode();
        plusGamebyUid();
      });
    });
  }
  Future plusGamebyUid() async {
    bool gameUidFound = true;
    plusGamebyUidState = false;
    if (PhlCommons.thatUid == null) return;
    Uri url = Uri.parse(pathPHP + "plusGAMEBYUID.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      gameUidFound = false;
      plusGamebyUidState = false;
    } else {
      gameUidFound = true;
    }
    if (response.statusCode == 200 && (gameUidFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGamesStatus =
            datamysql.map((xJson) => GamesPlus.fromJson(xJson)).toList();
      });
      plusGamebyUidState = true;
      // Voyon sil ya des changeents
      for (GameByUser _gameActif in myGames) {
        for (GamesPlus _gameRelu in myGamesStatus) {
          if (_gameRelu.gamecode == _gameActif.gamecode) {
            if (_gameActif.gamestatus != _gameRelu.gamestatus) {
              setState(() {
                _gameActif.gamestatus = _gameRelu.gamestatus;
                if (_gameActif.gamecode == PhlCommons.thisGameCode) {
                  PhlCommons.gameStatus = _gameActif.gamestatus;
                }
              });
            }
          }
          ;
        }
      }
    } else {}
  }
  Future promoteGame() async {
    promoteGameState = false;
    int _status = myGames[cestCeluiLa].gamestatus;
    _status = _status + 1;
    if (_status == 6) _status = 0;
    setState(() {
      myGames[cestCeluiLa].gamestatus = _status;
      PhlCommons.gameStatus = _status;
    });

    Uri url = Uri.parse(pathPHP + "promoteGAME.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "GAMESTATUS": _status.toString(),
      "GAMEDATE": DateTime.now().toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      promoteGameState = true;
    } else {}
  }
  Future SetGuOffGames() async {
    Uri url = Uri.parse(pathPHP + "setGUOFFGAME.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      setGuOffGamesState = true;
    } else {}
  }
  quelleAction(int _laquelle) {
    PhlCommons.thisGameCode = takeThisGameCode;
    if (_laquelle == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GameUser(),
          settings: RouteSettings(
            arguments: myPerso,
          ),
        ),
      );
    }

    if (_laquelle == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameVote(),
          settings: RouteSettings(
            arguments: myPerso,
          ),
        ),
      );
    }

    if (_laquelle == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameVoteResult(),
          settings: RouteSettings(
            arguments: myPerso,
          ),
        ),
      );
    }

  }
}
