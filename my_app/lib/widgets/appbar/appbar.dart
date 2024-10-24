import 'package:flutter/material.dart';

appBarFunction (text){
  return(AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(text),
          ],
        ),
        centerTitle: true,
      ));
 }