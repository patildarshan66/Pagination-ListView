import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum requestResponseState { error, dataReceived, loading }


//for show message
void showCustomSnackBar(
  BuildContext context,
  String msg, {
  Color color = Colors.green,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(msg),
    ),
  );
}

//for show loader
Widget getLoader(BuildContext context,{Color color}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
      ),
    ),
  );
}


//formate number
String numberFormate(dynamic number){
  var formatter = NumberFormat('#,##,000');
  return formatter.format(number);
}

//date formate
String formateDate(dynamic date){
  final formatter = DateFormat('MMMM d, yyyy');
  return formatter.format(date);
}

