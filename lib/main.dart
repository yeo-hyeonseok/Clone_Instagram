import 'package:flutter/material.dart';
import 'package:study_flutter_2/styles/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/shop.dart';
import 'pages/home.dart';
import 'pages/upload.dart';

void main() {
  runApp(MaterialApp(
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
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));

    if (result.statusCode == 200) {
      setState(() {
        posts = jsonDecode(result.body);
      });
    } else {
      showToast('데이터 요청 실패');
      throw Exception('요청 실패');
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

  getStorage() async {
    var storage = await SharedPreferences.getInstance();
    return storage;
  }

  void saveData() async {
    // 데이터를 반영구적으로 저장하고 싶다면 shared preference 쓰셈
    // => 로컬 스토리지랑 비슷한 개념임
    // => 유저가 캐시 삭제하지 않는 이상 계속 남아 있음
    // => 서버 부하 감소 및 빠른 데이터 로드 가능
    var storage = await SharedPreferences.getInstance();
    
    // 그냥 get과 getString의 차이는?
    // 가져온 자료를 String 타입으로 가져옴
    storage.setString('name', '차무식');

    // Map 타입의 데이터를 저장하려면 Json으로 바꿔줘야 함
    var temp = {'name': '차무식식'};
    storage.setString('real_name', jsonEncode(temp));
    
    var result = storage.getString('real_name') ?? '없음';
    
    print(jsonDecode(result)['name']);
  }
  
  void removeSaveData() async {
    var storage = await SharedPreferences.getInstance();
    
    // shared preference에서 데이터 삭제하는 방법
    storage.remove('name');
    print(storage.getString('name'));
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
                    builder: (context) => Upload(galleryImage:galleryImage, addPost: addPost, postId: posts.length + 1)
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
          saveData();
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








