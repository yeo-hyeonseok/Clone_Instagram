import 'package:flutter/material.dart';
import 'package:study_flutter_2/styles/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('게시글 작성하기'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close, color: Colors.black, size: 30,))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              width: double.infinity,
              height: 280,
              child: Image.file(galleryImage, width: double.infinity, height: 200, fit: BoxFit.cover,),
            ),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '내용을 입력해주세요',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ElevatedButton(
                  onPressed: (){},
                  child: Text('게시글 올리기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}






