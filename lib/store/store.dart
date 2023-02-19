import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// state를 전역적으로 사용하고 싶다면 provide 쓰셈
class Store1 extends ChangeNotifier {
  var follower = 0;
  var isFollowing = false;
  var profileImages = [];

  void setFollower() {
    !isFollowing ? follower -- : follower ++;
    notifyListeners();
  }

  void setIsFollowing() {
    isFollowing ? isFollowing = false : isFollowing = true;
  }

  void getProfileImages() async {
    var response = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    profileImages = jsonDecode(response.body);
    print(profileImages);
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = '차무식';
}