import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gameuser.dart';
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
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.red,
                iconSize: 30.0,
                tooltip: 'Home',
                onPressed: () {
//_timer.isActive { _timer.cancel()};

                  _timer?.cancel();

                  PhlCommons.thisGameCode = takeThisGameCode;
                  Navigator.pop(context);
                },
              ),
              Visibility(
                visible: isGmid,
                child: ElevatedButton(
                  child: Text(
                    'PROMOTE GAME N°' + takeThisGameCode.toString(),
                    style: GoogleFonts.averageSans(fontSize: 20.0),
                  ),
                  onPressed: () {
                    promoteGame();
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () => {null},
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: Text(myPerso.myPseudo)),
              Text(greeting),
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[
          getListGame(),
          getListGameUsers(),
          getListView()
        ]),
      ),
      bottomNavigationBar: Visibility(
        visible: true,
        child: Visibility(
          visible: takeThisGameCode > 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: Text(
                'Join LOBBY N°' + takeThisGameCode.toString(),
                style: GoogleFonts.averageSans(fontSize: 20.0),
              ),
              onPressed: () {
                PhlCommons.thisGameCode = takeThisGameCode;
                _timer?.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //      builder: (context) => const ConnectGame()),
                    builder: (context) => const GameUser(),
                    settings: RouteSettings(
                      arguments: myPerso,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ));
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
      // +1 CAr  si le GameUSer Vote cest donc quil est en ligne
      "GUSTATE": _state.toString(),
    };
    await http.post(url, body: data);
    changeStateGameUserState = true;
  }

  /* Future changeStatusGameUser(int _status, int _state) async {
    Uri url = Uri.parse(pathPHP + "changeStatusGameUser.php");
    // <PML> cause insta in display
    // Limiter à 1 ou 0 les valeurs possibles
    _state == 1 ? 1 : 0;
    _state == 0 ? 0 : 1;

    // changeStatusGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATUS": _status.toString(),
      'GUSTATE': _state.toString()
    };
    await http.post(url, body: data);
    changeStatusGameUserState = true;
    // Et On relit
    if (PhlCommons.thisGameCode > 0) getGameUsersByCode();
  }*/

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
    if (response.statusCode == 200 && (gameCodeFound)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGames = datamysql.map((xJson) => GameByUser.fromJson(xJson)).toList();
        PhlCommons.thisGameCode = myGames.last.gamecode; // ON prend le dernier
      });
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
                            Text(
                                myGames[index].gamecode.toString() +
                                    ' :' +
                                    statusGame[myGames[index].status],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25))
                          ],
                        )),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  myGames[index].isSelected = !myGames[index].isSelected;

                  if (myGames[index].isSelected) {
                    //
                    getGameUsersByCode();
                    //
                    isGmid = false;
                    isGmid = (PhlCommons.thatUid == myGames[index].gmid);
                    getGamePhotoSelectState = false;
                    cestCeluiLa = index;
                    getGamePhotoSelect();
                    takeThisGameCode = myGames[index].gamecode;

                    PhlCommons.thisGameCode = takeThisGameCode;
                    //PhlCommons.thatStatus=Gamers
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
                          child: Text(
                              Gamers[index].uname +
                                  " " +
                                  Gamers[index].gustatus.toString(),
                              style: TextStyle(
                                  //backgroundColor: Colors.white,
                                  color: (Gamers[index].gustate == 1)
                                      ? Colors.black
                                      : Colors.red,
                                  fontSize: 15)),
                          onPressed: () {
                            print("Gamers[index].gustate" +
                                Gamers[index].gustate.toString());
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isGmid,
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
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      setState(() {
        greeting = "Check ${DateTime.now().second}";

        checkAudika();
        getGameUsersByCode();
      });
    });
  }

  Future promoteGame() async {
    promoteGameState = false;
    int _status = myGames[cestCeluiLa].status;
    if (_status == 6) return;
    _status = _status + 1;
    myGames[cestCeluiLa].status = _status;
    Uri url = Uri.parse(pathPHP + "promoteGAME.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "GAMESTATUS": _status.toString(),
      "GAMEDATE": DateTime.now().toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      setState(() {
        promoteGameState = true;
      });
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
}
