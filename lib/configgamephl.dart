

//220701  Ajout du Path pour la PreProd

  import 'dart:core';


import 'package:flutter/material.dart';

const String  prefixPhoto ="upoad/PML_01_"; // Syntaxe
const   String  unknownCodeMaster = "Code Incorrect";

//const String pathPHP= "https://lamemopole.com/php/"; // PROD
const String pathPHP= "https://www.paulbrode.com/php/";  //DEV
List statusGame = ["CREATED" , "PHOTOCLOSED" , "INVITECLOSED","MEMECLOSED", "VOTECLOSED"];
List modeGame =  ["PUBLIC" , "PRIVATE"];
List msgNewGame = ["Nom Game ?" , "Photos Selected ? "];
List statusUser  =["DISABLED" , "ENABLED"];
Color  colorOK =Colors.green;
Color  colorKO=Colors.red;