import 'package:flutter/material.dart';
// 변수 중복 문제를 피하고 싶다면 as 키워드 사용하셈
import 'package:study_flutter_2/styles/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    // 스타일을 미리 지정해두고 전역적으로 적용시키려면 ThemeData
    // 웹개발로 치면 <style> 또는 css파일
    // but 위젯 하위에 존재하는 요소들은 적용 안될 수 있음 => 위젯은 자기랑 가까운 스타일을 우선적으로 따름
    theme: style.theme,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tabs = [Home(), Shop()];
  var currentTabIndex = 0;

  void setCurrentTabIndex(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  getDummyData() async {
    // 플러터에서 http 통신하는 법
    // 얘도 Future를 반환하는 함수임
    var response = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    print(jsonDecode(response.body));
  }
  
  // 위젯이 로드되면 동작할 내용 작성
  // initState 안에서는 async await 사용 불가
  // 쓰려면 따로 함수로 빼줘야 함
  @override
  void initState() {
    super.initState();

    getDummyData();
  }

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
              icon: Icon(Icons.add_box_outlined, color: Colors.black, size: 30,),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: tabs[currentTabIndex]
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
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: Offset(0, 0.5), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset('assets/images/sample.jpg'),
            Padding(padding: EdgeInsets.fromLTRB(10, 15, 10, 15), child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        padding: EdgeInsets.zero, // 패딩 설정
                        constraints: BoxConstraints(),
                        onPressed: (){},
                        icon: Icon(Icons.favorite, color: Colors.red, size: 20,)),
                    Text('100', style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
               Padding(
                 padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   children: [
                     Text('글쓴이'),
                     Text('내용')
                   ],
                 ),
               ),
              ],
            ),)
          ],
        ),
      )
    );
  }
}

class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('shop');
  }
}







