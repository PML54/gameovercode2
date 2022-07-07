import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gameover/configgamephl.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/phlcommons.dart';
import 'package:http/http.dart' as http;

class SelectPhotosPhl extends StatefulWidget {
  const SelectPhotosPhl({Key? key}) : super(key: key);

  @override
  State<SelectPhotosPhl> createState() => _SelectPhotosPhlState();
}

class _SelectPhotosPhlState extends State<SelectPhotosPhl> {
  String mafoto = 'assets/oursmacron.png';
  bool myBool = false;
  bool feuVert = false;
  double myWidth = 100;
  double myHeight = 100;
  List<PhotoBase> listPhotoBase = [];
  List<PhotoBase> listPhotoBaseReduce = [];
  List<GamePhotoSelect> listGamePhotoSelect = [];
  String thatGM = PhlCommons.listThatGM[0].gmpseudo;

  @override
  Widget build(BuildContext context) {
    mafoto = 'assets/oursmacron.png';
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
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                onPressed: () => {null},
                style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    textStyle: const TextStyle(
                        fontSize: 14,
                        backgroundColor: Colors.red,
                        fontWeight: FontWeight.bold)),
                child: Text('Game Master: ' + thatGM),
              ),
            ],
          ),
        ),
      ]),

      body: SafeArea(
        child: Row(children: <Widget>[
          getListViewSelected(),
          getListView(),
          //   getListView(),
        ]),
      ),
      //Container(child: getListViewReduce()),
      bottomNavigationBar: IconButton(
          icon: const Icon(Icons.save),
          iconSize: 35,
          color: Colors.red,
          tooltip: 'Save Selection',
          onPressed: () {
            PhlCommons.nbFotosGame = listPhotoBaseReduce.length;

            updateSelection();
          }),
    ));
  }

  Future getGamePhotoSelect() async {
    // Lire TABLE   GAMEPHOTOSELECT  et mettre dans  listgetGamePhotoSelect
    Uri url = Uri.parse(pathPHP + "readGAMEPHOTOSELECT.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listGamePhotoSelect =
            datamysql.map((xJson) => GamePhotoSelect.fromJson(xJson)).toList();
      });
    } else {}
  }

  Expanded getListView() {
    setState(() {});

    if (!feuVert) return (const Expanded(child: Text("Je Joue ........")));
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

                        // child: Image.network(mafoto,
                        child: Image.network(
                          "upload/" +
                              listPhotoBase[index].photofilename +
                              "." +
                              listPhotoBase[index].photofiletype,
                          width: (listPhotoBase[index].extraWidth) * 2.0,
                          height: (listPhotoBase[index].extraHeight) * 2.0,
                        )),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  listPhotoBase[index].isSelected =
                      !listPhotoBase[index].isSelected;
                  if (listPhotoBase[index].isSelected) {
                    listPhotoBase[index].extraColor = Colors.green;
                  } else {
                    listPhotoBase[index].extraColor = Colors.grey;
                  }
                });
              });
        });

    return (Expanded(child: listView));
  }

  Expanded getListViewSelected() {
    setState(() {});

    if (!feuVert) return (const Expanded(child: Text(".......")));
    setState(() {
      listPhotoBaseReduce.clear();
      for (PhotoBase _brocky in listPhotoBase) {
        if (_brocky.isSelected) {
          listPhotoBaseReduce.add(_brocky);
        }
      }
    });
    var listView = ListView.builder(
        itemCount: listPhotoBaseReduce.length,
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
                        color: listPhotoBaseReduce[index].extraColor,
                        border: Border.all()),

                    // child: Image.network(mafoto,
                    child: Image.network(
                        "upload/" +
                            listPhotoBaseReduce[index].photofilename +
                            "." +
                            listPhotoBaseReduce[index].photofiletype,
                        width: listPhotoBaseReduce[index].extraWidth,
                        height: listPhotoBaseReduce[index].extraHeight),
                  )),
                ],
              ),
              onTap: () {
                setState(() {
                  listPhotoBaseReduce[index].isSelected =
                      !listPhotoBaseReduce[index].isSelected;
                  if (listPhotoBaseReduce[index].isSelected) {
                    listPhotoBaseReduce[index].extraColor = Colors.green;
                  } else {
                    listPhotoBaseReduce[index].extraColor = Colors.grey;
                  }
                });
              });
        });

    return (Expanded(child: listView));
  }

  Future getPhotoBase() async {
    // Lire TABLE   PHOTOBASE et mettre dans  listPhotoBase
    Uri url = Uri.parse(pathPHP + "readPHOTOBASE.php");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPhotoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();

        feuVert = true;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getGamePhotoSelect();
    getPhotoBase();
    thatGM = PhlCommons.listThatGM[0].gmpseudo;
  }

  void updateSelection() async {
    String thisParam = "";

    int _gameid = PhlCommons.thisGameCode;
    for (PhotoBase _brocky in listPhotoBase) {
      if (_brocky.isSelected) {
        thisParam = thisParam + "|" + _brocky.photoid.toString();
      }
    }
    Uri url = Uri.parse(pathPHP + "updateGAMEPHOTOSELECT.php");
    var data = {
      //<TODO>
      "GAMEID": _gameid.toString(),
      "GROUPSEL": thisParam,
    };
    var res = await http.post(url, body: data);
    Navigator.pop(context);
  }
}
