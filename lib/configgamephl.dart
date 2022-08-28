//220701  Ajout du Path pour la PreProd

import 'dart:core';
import 'package:flutter/material.dart';

const String prefixPhoto = "upoad/PML_01_"; // Syntaxe
const String pathPHP= "https://lamemopole.com/php/"; // PROD
//const String pathPHP = "https://www.paulbrode.com/php/"; //DEV

const String unknownCodeMaster = "Code Incorrect";
List statusGame = [
  "Attente du départ",
  "Caption  en cours",
  "Fin des Captions",
  "Vote en cours",
  "Fin des Votes",
  "Résultats",
      "Aborted"
];
List statusGU = [
  "Attend",
  "Commente",
  "a Commenté",
  "Vote",
  "a Voté",
  "Resultats",
  "Aborted"
];
List modeGame = ["PUBLIC", "PRIVATE"];
List msgNewGame = ["Nom Game ?", "Photos Selected ? "];
List statusUser = ["DISABLED", "ENABLED"];
Color colorOK = Colors.green;
Color colorKO = Colors.red;
//String medalGold=""🥇 🥈 🥉";
List medals=[ "🥇","🥇" ,"🥈","🥉"];
String medalGold="🥇";
String medalSilver="🥈";
String medalBronze="🥉";

