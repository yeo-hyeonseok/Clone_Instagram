import 'package:flutter/material.dart';
import 'package:study_flutter_2/styles/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/Shop.dart';
import 'pages/Home.dart';
import 'pages/Upload.dart';
import 'package:provider/provider.dart';
import 'store/store.dart' as store;

void main() {
  // store 사용하는 방법 => 사용하길 원하는 위젯을 ChangeNotifierProvider으로 감싸주면 됨
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => store.Store1()),
      ChangeNotifierProvider(create: (context) => store.Store2()),
    ],
    child: MaterialApp(
      theme: style.theme,
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var currentTabIndex = 0;
  var posts = [];
  var isScrollForward = true;
  var requestCount = 0;
  late var galleryImage;

  void setCurrentTabIndex(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  void setIsScrollForward(String direction) {
    setState(() {
      if(direction == 'ScrollDirection.forward') {
        isScrollForward = true;
      } else if(direction == 'ScrollDirection.reverse') {
        isScrollForward = false;
      }
    });
  }

  void setGalleryImage(File path) {
    setState(() {
      galleryImage = path;
    });
  }

  void showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  void getPosts() async {
    var storage = await SharedPreferences.getInstance();

    // 데이터가 이미 있으면
    if(storage.getString('posts') != null) {
      print('있음ㅋ');
      var storageData = storage.getString('posts') ?? '없는데요';

      setState(() {
        posts = jsonDecode(storageData);
      });
    } else {
      // 데이터가 없으면
      var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));

      if (result.statusCode == 200) {
        storage.setString('posts', result.body);
        var storageData = storage.getString('posts') ?? '없는데요';

        setState(() {
          posts = jsonDecode(storageData);
        });
      } else {
        showToast('데이터 요청 실패');
        throw Exception('요청 실패');
      }
    }
  }

  void getMorePosts() async {
    setState(() {
      requestCount ++;
    });
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more$requestCount.json'));

    if(result.statusCode == 200) {
      setState(() {
        posts.add(jsonDecode(result.body));
      });
    } else {
      showToast('데이터 요청 실패');
      throw Exception('요청 실패');
    }
  }

  void addPost(post) {
    setState(() {
      posts.insert(0, post);
    });
  }

  @override
  void initState() {
    super.initState();

    getPosts();
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
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);

                if(image != null) {
                  setGalleryImage(File(image.path));
                  print(galleryImage);
                }

                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Upload(galleryImage:galleryImage, addPost: addPost, postId: posts.length)
                ));
              },
              icon: Icon(Icons.add_box_outlined, color: Colors.black, size: 30,),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: [Home(posts:posts, setIsScrollForward: setIsScrollForward, getMorePosts: getMorePosts), Shop()][currentTabIndex],
      ),
      // 플러터에서 탭 구현하기
      bottomNavigationBar: isScrollForward ? BottomNavigationBar(
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
      ) : null,
      );
  }
}








