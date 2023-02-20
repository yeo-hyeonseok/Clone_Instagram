import 'package:flutter/material.dart';
import '../util/notification.dart';

class Shop extends StatelessWidget {
  Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){
      showNotification();
    }, child: Text('알림 띄워'));
  }
}