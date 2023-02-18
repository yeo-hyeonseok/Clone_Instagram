import 'package:flutter/material.dart';

// state를 전역적으로 사용하고 싶다면 provide 쓰셈
class Store1 extends ChangeNotifier {
  var name = '차무식';
  var follower = 0;
}