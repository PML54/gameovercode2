import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gameuser.dart';
import 'package:gameover/main.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class GameSupervisor extends StatefulWidget {
  const GameSupervisor({Key? key}) : super(key: key);

  @override
  State<GameSupervisor> createState() => _GameSupervisorState();
}

// Permettre au GAmer  identifié par son UID
//List statusGame = ["CREATED" , "READY" , "MEMING","MEMECLOSED","VOTING" ,
// "VOTECLOSED","GAMEOVER","ABORTED"]
class _GameSupervisorState extends State<GameSupervisor> {
  GameCommons myPerso = GameCommons("xxxx", 0, 0);

  bool promoteGameState = false;
  bool isGmid = false;
  bool getGamePhotoSelectState = false;
  int getGamePhotoSelectError = -1;
  List<PhotoBase> listPhotoBase = [];
  bool getGamebyUidState = false;
  int getGamebyUidError = 0;
  List<GameByUser> myGames = [];
  String thatPseudo = PhlCommons.thatPseudo;
  int cestCeluiLa = 0;
  bool changeStatusGameUserState = false;
  int takeThisGameCode = 0;

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
                  PhlCommons.thisGameCode = takeThisGameCode;
                  Navigator.pop(context);
                },
              ),
              Visibility(visible: isGmid,
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
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[getListGame(), getListView()]),
      ),
      bottomNavigationBar: Visibility(
        visible: true,
        child: Visibility(
          visible:  takeThisGameCode>0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: Text(
                'Join LOBBY N°' + takeThisGameCode.toString(),
                style: GoogleFonts.averageSans(fontSize: 20.0),
              ),
              onPressed: () {
                PhlCommons.thisGameCode = takeThisGameCode;
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

  Future changeStatusGameUser(int _status) async {
    Uri url = Uri.parse(pathPHP + "changeStatusGameUser.php");
    changeStatusGameUserState = false;
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
      "GUSTATUS": _status.toString(),
    };
    await http.post(url, body: data);
    changeStatusGameUserState = true;
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
        getGamebyUidState = true;
        getGamebyUidError = 0;
      });
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
        getGamePhotoSelectState = true;
        getGamePhotoSelectError = 0;
      });
    } else {
      getGamePhotoSelectError = 2001;
    }
  }

  Expanded getListGame() {
    setState(() {});
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
                            )
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
                    isGmid=false;
                    isGmid= (PhlCommons.thatUid == myGames[index].gmid);
                    getGamePhotoSelectState = false;
                    cestCeluiLa = index;
                    getGamePhotoSelect();
                    takeThisGameCode = myGames[index].gamecode;
                    PhlCommons.thisGameCode = takeThisGameCode;
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
                  }
                });
              });
        });
    return (Expanded(child: listView));
  }

  Expanded getListView() {
    setState(() {});
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
    getGamebyUid();
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
}
