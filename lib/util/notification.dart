import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification(context) async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon.png');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    onSelectNotification: (payload) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Text('새 페이지')));
    }
  );
}

showNotification() async {

  var androidDetails = AndroidNotificationDetails(
    'flutter_study_2_notify',
    '알림 기능 테스트임',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '속보)',
      '알림 기능 잘 동작함',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
  );
}

// 사용자에게 주기적으로 알림을 띄우기
showNotification2() async {

  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.zonedSchedule(
      2,
      '속보)',
      '알림 기능 3초 후에 잘 동작함',
      // 현재 시간 아님, 현재 폰의 시간임
      // 매일 오전 8시 30분에 알림 띄우기
      makeDate(8, 30, 0),
      // 코드 실행한 다음 3초 후에 알림 띄우기
      //tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,

      // 알림을 주기적으로 원하는 시간에 띄우고 싶다면
      // tz.TZDateTime.now() 기준
      matchDateTimeComponents: DateTimeComponents.time
  );

  // 알림을 주기적으로 띄울 수 있는 또 다른 방법
  // 코드 실행 시점에서 24시간 이후 알림 띄우기
  /*notifications.periodicallyShow(
    3,
    '제목3',
    '내용3',
    RepeatInterval.daily,
    NotificationDetails(android: androidDetails, iOS: iosDetails),
    androidAllowWhileIdle: true
  );*/
}

// 시간 세팅해주는 함수
makeDate(hour, min, sec){
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}