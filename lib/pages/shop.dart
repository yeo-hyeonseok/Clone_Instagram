import 'package:flutter/material.dart';
import '../util/notification.dart';

class Shop extends StatelessWidget {
  Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: (){
          showNotification();
        }, child: Text('알림 바로 띄우기')),
        TextButton(onPressed: (){
          showNotification2();
        }, child: Text('3초 후에 알림 띄우기')),
      ],
    );
  }
}