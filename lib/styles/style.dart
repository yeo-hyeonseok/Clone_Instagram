// 플러터 기본 위젯들 사용하려면 import 필요
import 'package:flutter/material.dart';

// 특정 변수를 다른 파일에서 사용할 수 없도록 만들고 싶다면 _ 붙이셈
var _value = 'do not use';

var theme = ThemeData(
    iconTheme: IconThemeData(color: Colors.orange),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          fontSize: 25
      ),
      color: Colors.white,
    ),
    textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.red,
          fontSize: 30
        ),
        bodyText2: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 30
        )
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.orange
      )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(

      )
    )
);
