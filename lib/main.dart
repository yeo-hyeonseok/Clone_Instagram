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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tabContents = [Home(), Shop()];
  var currentTabIndex = 0;

  void setCurrentTabIndex(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.add_box_outlined, color: Colors.black, size: 30,),
            ),
          )
        ],
      ),
      body: Container(
          child: tabContents[currentTabIndex]
        ),
      // 플러터에서 탭 구현하기
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // onPressed랑 똑같음
        onTap: (index){
          setCurrentTabIndex(index);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵'),
        ],
      ),
      );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('home');
  }
}

class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('shop');
  }
}







