//220701  Ajout du Path pour la PreProd

import 'dart:core';
import 'package:flutter/material.dart';

const String prefixPhoto = "upoad/PML_01_"; // Syntaxe
//const String pathPHP= "https://lamemopole.com/php/"; // PROD
const String pathPHP = "https://www.paulbrode.com/php/"; //DEV

const String unknownCodeMaster = "Code Incorrect";
List statusGame = [
  "READY",
  "MEMING",
  "MEMECLOSED",
  "VOTING",
  "VOTECLOSED",
  "ABORTED"
];
List modeGame = ["PUBLIC", "PRIVATE"];
List msgNewGame = ["Nom Game ?", "Photos Selected ? "];
List statusUser = ["DISABLED", "ENABLED"];
Color colorOK = Colors.green;
Color colorKO = Colors.red;
