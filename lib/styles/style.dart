// 플러터 기본 위젯들 사용하려면 import 필요
import 'package:flutter/material.dart';

// 특정 변수를 다른 파일에서 사용할 수 없도록 만들고 싶다면 _ 붙이셈
var _value = 'do not use';

var theme = ThemeData(
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      color: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(
        color: Colors.pinkAccent
      )
    ),
);
