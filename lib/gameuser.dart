import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:http/http.dart' as http;
class GameUser extends StatefulWidget {
  GameUser({Key? key}) : super(key: key);

  @override
  State<GameUser> createState() => _GameUserState();
}

class _GameUserState extends State<GameUser> {
  bool myBool = false;
  bool feuOrange = true;

  bool getGamebyCodeState = false;
  int getGamebyCodeError = -1;
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


  bool createMemeState = false;
  int createMemeError = -1;

  //

  int totalSeconds = 0;
  TextEditingController legendeController = TextEditingController();
 
  String thatPseudo = PhlCommons.thatPseudo;
  String memeLegende = "";
  bool timeOut = false;
  int timerMemeGame = 0;
  int cestCeluiLa = 0;

  //  Chrono
  Duration countdownDuration = const Duration(seconds: 40);
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;

  @override
  Widget build(BuildContext context) {
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
                  child: Text(thatPseudo)),
              Text(totalSeconds.toString())
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
        visible: !timeOut,
        child: IconButton(
            icon: const Icon(Icons.save),
            iconSize: 35,
            color: Colors.red,
            tooltip: 'Save Selection',
            onPressed: () {
              createMeme();
              stopTimer();
            }),
      ),
    ));
  }

  Future getGamebyCode() async {
    int _thisGameCode = PhlCommons.thisGameCode;
    bool gameCodeFound = true;
    Uri url = Uri.parse(pathPHP+"getGAMEBYCODE.php");
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
      });
    } else {}
  }

  Future getGamePhotoSelect() async {
    getGamePhotoSelectState = false;
    getGamePhotoSelectError = -1;

    Uri url = Uri.parse(pathPHP+"getGAMEPHOTOS.php");
    var data = {
      "GAMEID": PhlCommons.thisGameCode.toString(),
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

  Future getGameUser() async {
    getGameUserState = false;

    Uri url = Uri.parse(pathPHP+"getGAMEUSER.php");
    var data = {
      "GAMECODE": PhlCommons.thisGameCode.toString(),
      "GUPSEUDO": PhlCommons.thatPseudo
    };
    http.Response response = await http.post(url, body: data);
    getGameUserState = false;


    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        getGameUserState = true;
        listGuy = datamysql.map((xJson) => GameUsers.fromJson(xJson)).toList();
      });
    } else {


    }

  }

  Expanded getget() {
    if (!getGamePhotoSelectState) {
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
    if (!getGamebyCodeState) {
      return (const Expanded(child: Text(".............")));
    }
    //
    if (feuOrange) {
      setState(() {
        //
        timerMemeGame = myGuGame[0].gametimememe;
        countdownDuration = Duration(seconds: timerMemeGame);
      //  Duration duration = Duration();
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
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            color: listPhotoBase[index].extraColor,
                            border: Border.all()),
                        child: Column(
                          children: [
                            Image.network(
                              "upload/" +
                                  listPhotoBase[index].photofilename +
                                  "." +
                                  listPhotoBase[index].photofiletype,
                              width: (listPhotoBase[index].extraWidth),
                              height: (listPhotoBase[index].extraHeight),
                            ),
                          ],
                        )),
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
    int _thisGameCode = PhlCommons.thisGameCode;
    getMemeUserState = false;
    getMemeUserError = -1;
    Uri url = Uri.parse(pathPHP+"getMEMEBYUSER.php");
    var data = {
      "GAMECODE": _thisGameCode.toString(),
      "GUPSEUDO": PhlCommons.thatPseudo,
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

    getGamebyCode();
    getGamePhotoSelect();
    getGameUser();
    getMemeUser(); //
  }

  Future createMeme() async {
    Uri url = Uri.parse(pathPHP+"createMEME.php");

    for (PhotoBase _brocky in listPhotoBase) {
      var data = {
        "PHOTOID": _brocky.photoid.toString(),
        "GAMECODE": PhlCommons.thisGameCode.toString(),
        "GUPSEUDO": PhlCommons.thatPseudo,
        "MEMETEXT": _brocky.memetempo,
      };

      if (_brocky.memetempo.length > 1) {
        var res = await http.post(url, body: data);
      }
      //<TODO>  relecture
    }
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

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  buildTime() {

    totalSeconds = duration.inMinutes * 60 + duration.inSeconds;

  }
}
