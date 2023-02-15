import 'package:flutter/material.dart';
import 'package:study_flutter_2/styles/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  void setPosts(data) {
    setState(() {
      posts = data;
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

  getPosts() async {
    // 플러터에서 http 통신하는 법
    // 얘도 Future를 반환하는 함수임
    // http 말고 dio 패키지도 한번 써보셈, 예외처리 하기 쉬움
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));

    if (result.statusCode == 200) {
      setPosts(jsonDecode(result.body));
    } else {
      showToast('데이터 요청 실패');
      throw Exception('요청 실패');
    }
  }

  getMorePosts() async {
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
  
  // 위젯이 로드되면 동작할 내용 작성
  // initState 안에서는 async await 사용 불가
  // 쓰려면 따로 함수로 빼줘야 함
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
                // 사용자의 갤러리에서 이미지를 가져오고 싶다면 image-picker
                var picker = ImagePicker();
                // 갤러리 대신 카메라를 띄우고 싶다면 imageSource.camera
                // 여러 이미지를 고르고 싶다면 pickMultiImage()
                // 이미지가 아니라 비디오를 고르고 싶다면 pickVideo() 쓰셈
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null) {
                  setGalleryImage(File(image.path));
                  print(galleryImage);
                }
                // 내비게이터
                // => 새로운 페이지가 기존 페이지 위에 덮어 씌어지는 것
                // => 페이지들을 Stack으로 관리하기 때문에 뒤로가기 버튼이 동작함
                // 여기서 context는 MaterialApp에 대한 정보
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Upload(galleryImage:galleryImage)
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

class Home extends StatefulWidget {
  Home({Key? key, this.posts, this.setIsScrollForward, this.getMorePosts}) : super(key: key);

  final posts;
  final setIsScrollForward;
  final getMorePosts;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 스크롤 관련 정보를 가지고 있는 클래스
  var scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 왼쪽의 변수가 변할 때마다 특정 코드를 실행시키고 싶다면 리스너 사용하셈
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        widget.getMorePosts();
        print('끝');
      }
      widget.setIsScrollForward(scroll.position.userScrollDirection.toString());
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // 리스트가 비었는지 안 비었는지 검사
    if(widget.posts.isNotEmpty) {
      return ListView.builder(
          controller: scroll,
          itemCount: widget.posts.length,
          itemBuilder: (context, index) => Container(
            margin: index + 1 == widget.posts.length ? EdgeInsets.fromLTRB(0, 25, 0, 25) : EdgeInsets.fromLTRB(0, 25, 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 0.6), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Image.network(widget.posts[index]['image'],width: double.infinity, height: 280, fit: BoxFit.cover,),
                Padding(padding: EdgeInsets.fromLTRB(10, 15, 10, 15), child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero, // 패딩 설정
                            constraints: BoxConstraints(),
                            onPressed: (){},
                            icon: Icon(Icons.favorite, color: Colors.red, size: 20,)),
                        Text('${widget.posts[index]['likes']}', style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('${widget.posts[index]['user']}', style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),),
                          Text('${widget.posts[index]['content']}')
                        ],
                      ),
                    ),
                  ],
                ),)
              ],
            ),
          )
      );
    } else {
      return Center(child: CircularProgressIndicator(
        color: Colors.redAccent,
      ));
    }

  }
}

class Shop extends StatelessWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('shop');
  }
}

class Upload extends StatelessWidget {
  Upload({Key? key, this.galleryImage}) : super(key: key);

  final galleryImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이미지 업로드 화면임'),
          Image.file(galleryImage),
          TextField(),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),
    );
  }
}








