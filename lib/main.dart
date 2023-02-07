import 'package:flutter/material.dart';
// 변수 중복 문제를 피하고 싶다면 as 키워드 사용하셈
import 'package:study_flutter_2/styles/style.dart' as style;

void main() {
  runApp(MaterialApp(
    // 스타일을 미리 지정해두고 전역적으로 적용시키려면 ThemeData
    // 웹개발로 치면 <style> 또는 css파일
    // but 위젯 하위에 존재하는 요소들은 적용 안될 수 있음 => 위젯은 자기랑 가까운 스타일을 우선적으로 따름
    theme: style.theme,
    home: MyApp(),
  ));
}

// 몇몇 요소의 경우 그냥 변수로 만들어 놨다가 사용하는 것도 나쁘지 않을지도 (특히 글자)
var textStyle = TextStyle(
  color: Colors.grey.shade600,
  fontWeight: FontWeight.bold,
  fontSize: 18
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram', style: TextStyle(
          color: Colors.black
        ),),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.add_box_outlined, color: Colors.grey.shade800, size: 35,),
            ),
          )
        ],
      ),
      body: Container(
          child: Column(
            children: [
              Icon(Icons.star),
              // 원하는 ThemeData의 내용을 불러오려면 Theme.of
              Text('ㅋㅋ', style: Theme.of(context).textTheme.bodyText1,),
              Text('ㅋㅋ', style: Theme.of(context).textTheme.bodyText2,),
              TextButton(onPressed: (){}, child: Text('ㅋ'))
            ],
          ),
        ),
      );
  }
}

