import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamemanager.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/gameuser.dart';
import 'package:gameover/phlcommons.dart';

import 'package:http/http.dart' as http;
class ConnectGame extends StatefulWidget {
  const ConnectGame({Key? key}) : super(key: key);

  @override
  State<ConnectGame> createState() => _ConnectGameState();
}

class _ConnectGameState extends State<ConnectGame> {
  String thisUserActif = "";
  String numTape = "";
  String numSpace = "";
  String thatGameName = ""; //<TODO>
  String ipv4name = "**.**.**";
  bool isGm = true;
  bool isGu = false;
  bool gmConnected = false;
  bool guConnected = false;
  TextEditingController gameNameController = TextEditingController();
  String msgButton1 = "";
  String msgButton10 = "Valider";
  String msgButton11 = "Press ";

  @override
  Widget build(BuildContext context) {
    //  return
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Connect Game',
        home: Scaffold(
          appBar: AppBar(
            title: Row(
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
                Align(
                    alignment: Alignment.topLeft,
                    child: Image.network("assets/marin2.png")),
                const Text(" Code ?", style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          body: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(thisUserActif,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    const Text('Master'),
                    Checkbox(
                      value: isGm,
                      onChanged: (value) {
                        setState(() {
                          isGm = !isGm;
                          isGu = !isGm;
                        });
                      },
                    ),
                    const Text('User'),
                    Checkbox(
                      value: !isGm,
                      onChanged: (value) {
                        setState(() {
                          isGm = !isGm;
                          isGu = !isGm;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: isGu,
                  child: SizedBox(
                    width: 120,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: TextField(
                        controller: gameNameController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Pseudo ?",
                          fillColor: Colors.blue,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            if (gameNameController.text.isNotEmpty) {
                              thatGameName =
                                  gameNameController.text.toUpperCase();
                            }
                            if (thatGameName.length > 8) {
                              thatGameName = thatGameName.substring(0, 8);
                            }
                          });
                        },
                        onSubmitted: (text) {
                          setState(() {
                            gameNameController.text = thatGameName;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(numSpace,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      // Valide
                      whatChecker()
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 10,
                            backgroundColor: Colors.green,
                            fontWeight: FontWeight.bold)),
                    child: Text(msgButton1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ],
              ),
              dispRow(1, 2, 3),
              dispRow(4, 5, 6),
              dispRow(7, 8, 9),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ElevatedButton(
                        onPressed: () => {pressButton(-2)},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 14,
                                backgroundColor: Colors.red,
                                fontWeight: FontWeight.bold)),
                        child: const Text('CLEAR')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () => {pressButton(0)},
                        child: const Text('0')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ElevatedButton(
                        onPressed: () => {pressButton(-1)},
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 20,
                                backgroundColor: Colors.red,
                                fontWeight: FontWeight.bold)),
                        child: const Text('<')),
                  ),
                  Visibility(
                    visible: guConnected,
                    child: ElevatedButton(
                      onPressed: () => {pressContinue()},
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          textStyle: const TextStyle(
                              fontSize: 20,
                              backgroundColor: Colors.red,
                              fontWeight: FontWeight.bold)),
                      child: const Text(' PRESS '),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future checkCodeMaster(String _thatcode) async {
    playSound(2);
    Uri url = Uri.parse(pathPHP + "checkGAMEMASTER.php");
    var data = {
      "GMPWD": _thatcode,
    };
    try {
      var response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        var datamysql = jsonDecode(response.body) as List;
        setState(() {
          PhlCommons.listThatGM =
              datamysql.map((xJson) => GameMasters.fromJson(xJson)).toList();
          thisUserActif = PhlCommons.listThatGM[0].gmpseudo;
          playSound(4);
          numTape = "";
          numSpace = "";
          gmConnected = true;
          PhlCommons.isAdmin = 1;
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GameManager();
          }));
        });
      }
    } catch (error) {
      setState(() {
        thisUserActif = unknownCodeMaster;
        playSound(3);
      });
    }
  }

  Future checkCodePlayer(String _thatcode) async {
    // playSound(2);
    bool feuRouge = false;
    Uri url = Uri.parse(pathPHP + "checkCODEPLAYER.php");
    var data = {"GAMECODE": _thatcode, "GUPSEUDO": thatGameName};
    try {
      http.Response response = await http.post(url, body: data);
      feuRouge = false;
      if (response.body.toString() == 'ERR_1002') {
        feuRouge = true; // Pas trouvé
      }

      if (response.statusCode == 200 && feuRouge == false) {
        // Code Existe
        //  Code Existe  o erecupére e GAMEID

        var datamysql = jsonDecode(response.body) as List;
        setState(() {
          PhlCommons.listThatGame =
              datamysql.map((xJson) => Games.fromJson(xJson)).toList();
          playSound(4);

// A ce niveau on a trouvé le Jeu
// Regardons si il existe un record GAMEUSERS qui conyient  le GUPSEUDO  + GAECODE

          numTape = "";
          numSpace = "";
          guConnected = true;
          checkGameUser(_thatcode);
          // Maintenat on pei-ur mettre à Jour la DATE et l'IP  et le status
          updateGameUser(_thatcode);
        });
      }
    } catch (error) {
      setState(() {
        thisUserActif = unknownCodeMaster;
        playSound(3);
      });
    }

    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GameUser();
    }));*/
  }

  Future checkGameUser(String _thatcode) async {
    Uri url = Uri.parse(pathPHP + "checkGAMEUSER.php");
    var data = {"GAMECODE": _thatcode, "GUPSEUDO": thatGameName};
    try {
      http.Response response = await http.post(url, body: data);

      guConnected = true;
      if (response.body.toString() == 'ERR_1002') {
      } else {
        guConnected = true;
        PhlCommons.thisGameCode = int.parse(_thatcode);
        PhlCommons.thatPseudo = thatGameName; //???

      }
    } catch (error) {
      setState(() {
        thisUserActif = unknownCodeMaster;
        playSound(3);
      });
    }
  }

  Row dispRow(int i, int j, int k) {
    return (Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () => {pressButton(i)},
            child: Text(i.toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () => {pressButton(j)}, child: Text(j.toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () => {pressButton(k)}, child: Text(k.toString())),
        ),
      ],
    ));
  }

  Future getIP() async {
    final ipv4 = await Ipify.ipv4();

    ipv4name = ipv4;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getIP();
      msgButton1 = msgButton10; // Valid
    });
  }

  void playSound(int lequel) {
    if (1 == 1) {
      final player = AudioCache();
      var lenewVolume = 0.005; // securité N°1
      switch (lequel) {
        case 1:
          //   player.play('1024.mp3', volume: lenewVolume);
          break;
        case 2:
          player.play('phl-rech.wav', volume: lenewVolume);
          break;
        case 3:
          player.play('occupied4.mp3', volume: lenewVolume);
          break;

        case 4:
          // player.play('connectok4.mp3', volume: 0.05);
          break;
      }
    }
  }

  pressButton(int i) {
    setState(() {
      if (numTape.length < 8) {
        if (i >= 0) {
          playSound(1);
          numTape = numTape + i.toString();
        } else {
          numTape = numTape.substring(0, numTape.length - 1);
        }
      } else if (i == -1) {
        numTape = numTape.substring(0, numTape.length - 1);
      }
      if (i == -2) {
        numSpace = "";
        numTape = "";
        thisUserActif = "";
      }
      numSpace = "";
      for (int j = 0; j < numTape.length; j++) {
        numSpace = numSpace + numTape.substring(j, j + 1);
        //numSpace = numSpace + '*';

        if (j == 1 || j == 3 || j == 5) numSpace = numSpace + ".";
      }
    });
  }

  Future updateGameUser(String _thatcode) async {
    String _today = DateTime.now().toString();

    Uri url = Uri.parse(pathPHP + "updateGAMEUSER.php");
    var data = {
      "GAMECODE": _thatcode,
      "GUPSEUDO": thatGameName,
      "GUSTATUS": "1",
      "GULAST": _today,
      "GUIPV4": ipv4name
    };

    try {
      http.Response response = await http.post(url, body: data);

      guConnected = true;
      if (response.body.toString() == 'ERR_1005') {}
    } catch (error) {
      setState(() {
        thisUserActif = " Non Prévu";
        playSound(3);
      });
    }
  }

  //
  void whatChecker() {
    if (isGm) checkCodeMaster(numTape);
    if (isGu) checkCodePlayer(numTape);
  }

  pressContinue() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GameUser();
    }));
  }
}
