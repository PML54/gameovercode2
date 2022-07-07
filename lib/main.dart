import 'package:flutter/material.dart';
import 'package:gameover/admin/admingame.dart';
import 'package:gameover/connectgame.dart';
import 'package:gameover/gamephlclass.dart';
import 'package:gameover/mementoes.dart';
import 'package:gameover/memolike.dart';
import 'package:gameover/randomeme.dart';
import 'package:gameover/userconnect.dart';
import 'package:gameover/usercreate.dart';
import 'package:gameover/phlcommons.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(title: 'Navigation Basics', home: MenoPaul()));
}
class MenoPaul extends StatefulWidget {
  const MenoPaul({Key? key}) : super(key: key);
  @override
  State<MenoPaul> createState() => _MenoPaulState();
}
class _MenoPaulState extends State<MenoPaul> {
  bool isAdmin = false;
  bool isGamer = false;
  String connectedGuy = "";
  List<MemopolUsers> listMemopolUsers = [];
GameCommons myPerso = new GameCommons("xxxx", 0,0) ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' 0705 LAMEMOPOLE ' + myPerso.myPseudo,
          style: GoogleFonts.averageSans(fontSize: 18.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height
                  //set minimum height equal to 100% of VH
                  ),
          width: MediaQuery.of(context).size.width,
          //make width of outer wrapper to 100%
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.orange,
                Colors.deepOrangeAccent,
                Colors.red,
                Colors.redAccent,
              ],
            ),
          ),
          //show linear gradient background of page
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !isGamer,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Text(
                        'CONNEXION',
                        style: GoogleFonts.averageSans(fontSize: 25.0),
                      ),
                      onPressed: () async {
                        listMemopolUsers = await (Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        ));
                        setState(() {
                          connectedGuy = listMemopolUsers[0].uname;


                          if (listMemopolUsers[0].uprofile & 128 == 128) {
                            isAdmin = true;
                          }
                          if (listMemopolUsers[0].uprofile & 1 == 1) {
                            isGamer = true;
                          }
                          myPerso.myPseudo= listMemopolUsers[0].uname;
                          myPerso.myProfile= listMemopolUsers[0].uprofile;
                          myPerso.myUid= listMemopolUsers[0].uid;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Visibility(
                      visible: isGamer,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          child: Text(
                            'GAME   ',
                            style: GoogleFonts.averageSans(fontSize: 25.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ConnectGame()),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isGamer,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          child: Text(
                            'RANDOM',
                            style: GoogleFonts.averageSans(fontSize: 25.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  RandoMeme(),
                                settings: RouteSettings(
                                  arguments: myPerso,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Visibility(
                      visible: isGamer,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          child: Text(
                            'CAPTION',
                            style: GoogleFonts.averageSans(fontSize: 25.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  Memento(),
                                settings: RouteSettings(
                                  arguments: myPerso,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isGamer,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          child: Text(
                            'FAVORI',
                            style: GoogleFonts.averageSans(fontSize: 25.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  Memolike(),
                                settings: RouteSettings(
                                  arguments: myPerso,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isAdmin,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Text(
                        'ADMIN',
                        style: GoogleFonts.averageSans(fontSize: 25.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminGame()),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: !isGamer,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      child: Text(
                        'NEW GAMER',
                        style: GoogleFonts.averageSans(fontSize: 25.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreatePage()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: false,
        child: IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 35,
            color: Colors.green,
            tooltip: 'Unused',
            onPressed: () {
              setState(() {});
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isAdmin = false;
      isGamer = false;
     // myPerso=GameCommons(" ", 0);

    });
  }
}
