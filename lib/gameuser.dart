import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:http/http.dart' as http;

class GameUser extends StatefulWidget {
  const GameUser({Key? key}) : super(key: key);

  @override
  State<GameUser> createState() => _GameUserState();
}

class _GameUserState extends State<GameUser> {
  GameCommons myPerso = GameCommons("xxxx", 0, 0);
  bool myBool = false;
  bool feuOrange = true;
  List<Games> myGuGame = []; //  only one Games
  bool getGamePhotoSelectState = false;
  int getGamePhotoSelectError = -1;
  List<PhotoBase> listPhotoBase = [];
  bool getGameUserState = false;
  int getGameUserError = -1;
  List<GameUsers> listGuy = [];
  bool getMemeUserState = false;
  int getMemeUserError = -1;
  List<Memes> myGuMeme = [];
  bool getGamebyUidState = false;
  int getGamebyUidError = 0;
  List<GameByUser> myGames = [];
  bool createMemeState = false;
  int createMemeError = -1;
  int totalSeconds = 0;
  TextEditingController legendeController = TextEditingController();
  String thatPseudo = PhlCommons.thatPseudo;
  String memeLegende = "";
  bool timeOut = false;
  int timerMemeGame = 0;
  int cestCeluiLa = 0;
  bool getGamebyCodeState = false;
  int getGamebyCodeError = 0;
  bool changeStatusGameUserState = false;

  //  Chrono
  Duration countdownDuration = const Duration(seconds: 59);
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;


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
    myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(actions: <Widget>[
        Expanded(
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                iconSize: 30.0,
                tooltip: 'Home',
                onPressed: () {
                  stopTimer();
                  Navigator.pop(context);
                },
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
              Text(PhlCommons.thisGameCode.toString() +
                  '   ' +
                  totalSeconds.toString() +
                  's')
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: Row(children: <Widget>[
          Align(child: buildTime()),
          getget(),
          getListView(),
        ]),
      ),
      bottomNavigationBar: Visibility(
        // visible: !timeOut,
        visible: true,
        child: IconButton(
            icon: const Icon(Icons.save),
            iconSize: 35,
            color: Colors.red,
            tooltip: 'Save Selection',
            onPressed: () {
              createMeme();
              stopTimer();
              changeStatusGameUser(2);
              Navigator.pop(context);
            }),
      ),
    ));
  }

  buildTime() {

    totalSeconds = duration.inMinutes * 60 + duration.inSeconds;

    if (totalSeconds <= 1) {
      createMeme();
      stopTimer();
      changeStatusGameUser(4);//MEME CLOSED
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
      "GUSTATUS": (_status +1) .toString(),
    };
    await http.post(url, body: data);
    changeStatusGameUserState = true;
  }

  Future createMeme() async {
    Uri url = Uri.parse(pathPHP + "createMEME.php");
    for (PhotoBase _brocky in listPhotoBase) {
      var data = {
        "PHOTOID": _brocky.photoid.toString(),
        "GAMECODE": PhlCommons.thisGameCode.toString(),
        "UID": PhlCommons.thatUid.toString(),
        "MEMETEXT": _brocky.memetempo,
      };

      if (_brocky.memetempo.length > 1) {
        await http.post(url, body: data);
      }
      //<TODO>  relecture
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
        getGamePhotoSelect(); // Il faut le GameCore
      });
    } else {}
  }

  Future getGamebyUid() async {
    Uri url = Uri.parse(pathPHP + "getGAMEBYUID.php");
    var data = {
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      getGamebyUidState = false;
      getGamebyUidError = 1001;
    }
    if (response.statusCode == 200 && (getGamebyUidError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGames = datamysql.map((xJson) => GameByUser.fromJson(xJson)).toList();

        //PhlCommons.thisGameCode = myGames.last.gamecode;
        getGamePhotoSelect(); // Il faut le GameCore
        getGamebyCode(); // H-eu
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
        // On Empie c'est bon
        getMemeUser();
      });
    } else {
      getGamePhotoSelectError = 2001;
    }
  }

  Expanded getget() {
    if (!getGamebyUidState || !getGamePhotoSelectState) {
      return Expanded(
        child: Column(
          children: const [
            (Text('Wait Wait ....')),
          ],
        ),
      );
    }

    setState(() {
      legendeController.text = listPhotoBase[cestCeluiLa].memetempo;
      legendeController.selection = TextSelection.fromPosition(
          TextPosition(offset: legendeController.text.length));
    });
    return Expanded(
        child: (Column(
      children: [
        TextField(
          controller: legendeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Meme?",
          ),
          onChanged: (text) {
            setState(() {
              memeLegende = text;
              legendeController.text = memeLegende;
              legendeController.selection = TextSelection.fromPosition(
                  TextPosition(offset: legendeController.text.length));
              listPhotoBase[cestCeluiLa].memetempo = memeLegende;
            });
          },
        ),
        Image.network(
          "upload/" +
              listPhotoBase[cestCeluiLa].photofilename +
              "." +
              listPhotoBase[cestCeluiLa].photofiletype,
          width: (listPhotoBase[cestCeluiLa].extraWidth * 2),
          height: (listPhotoBase[cestCeluiLa].extraHeight * 2),
        ),
      ],
    )));
  }

  Expanded getListView() {
    setState(() {});
    if (!getGamebyUidState || !getGamePhotoSelectState) {
      return (const Expanded(child: Text(".............")));
    }
    //
    if (feuOrange) {
      setState(() {
        //
        timerMemeGame = myGuGame[0].gametimememe;
        countdownDuration = Duration(seconds: timerMemeGame);

        reset();
        countDown = true;
        startTimer();
        feuOrange = false;
        //
      });
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
                      /*margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(2.0),0
                        decoration: BoxDecoration(
                            color: listPhotoBase[index].extraColor,
                            border: Border.all()),*/
                      child: Image.network(
                        "upload/" +
                            listPhotoBase[index].photofilename +
                            "." +
                            listPhotoBase[index].photofiletype,
                        /*width: (listPhotoBase[index].extraWidth),
                              height: (listPhotoBase[index].extraHeight),*/
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  cestCeluiLa = index;
                });
              });
        });
    return (Expanded(child: listView));
  }

  Future getMemeUser() async {
    getMemeUserState = false;
    getMemeUserError = -1;
    Uri url = Uri.parse(pathPHP + "getMEMEBYUSER.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "UID": PhlCommons.thatUid.toString(),
    };
    http.Response response = await http.post(url, body: data);
    if (response.body.toString() == 'ERR_1001') {
      getMemeUserError = 1001;
    }
    if (response.statusCode == 200 && (getMemeUserError != 1001)) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        myGuMeme = datamysql.map((xJson) => Memes.fromJson(xJson)).toList();
        getMemeUserState = true;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    reset();
    getGamebyUidState = true;
    getGamebyCode(); // H-eu

    changeStatusGameUser(2);//MEMING 
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
}
