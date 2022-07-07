

//220701  Ajout du Path pour la PreProd

  import 'dart:core';
const String  prefixPhoto ="upoad/PML_01_"; // Syntaxe
const   String  unknownCodeMaster = "Code Incorrect";

const String pathPHP= "https://lamemopole.com/php/"; // PROD
//const String pathPHP= "https://www.paulbrode.com/php/";  //DEV
List statusGame = ["CREATED" , "PHOTOCLOSED" , "INVITECLOSED","MEMECLOSED", "VOTECLOSED"];
List modeGame =  ["PUBLIC" , "PRIVATE"];
List msgNewGame = ["Nom Game ?" , "Photos Selected ? "];
List statusUser  =["DISABLED" , "ENABLED"];
