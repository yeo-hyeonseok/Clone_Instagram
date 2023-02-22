import 'package:flutter/material.dart';
import '../pages/profile.dart';

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
                widget.posts[index]['image'].runtimeType.toString() == '_File' ?
                Image.file(widget.posts[index]['image'],width: double.infinity, height: 280, fit: BoxFit.cover,) :
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
                          // 일반 위젯에도 특정 이벤트에 따른 기능을 구현하고 싶다면 gestureDetector
                          GestureDetector(
                            // 페이지 전환 애니메이션 자유롭게 넣고 싶으며 PageRouteBuilder 쓰셈
                            onTap: (){
                              Navigator.push(context,
                                PageRouteBuilder(
                                  // a1 => animation object, 페이지 전환 경과 정보를 담고 있음 0~1
                                  // a2 => animation object, 기존 페이지(덮여지는 페이지)에 애니메이션을 주고 싶을 때 사용함
                                  pageBuilder: (context, a1, a2) => Profile(),
                                  transitionsBuilder: (context, a1, a2, child) => FadeTransition(opacity: a1, child: child,),
                                  transitionDuration: Duration(milliseconds: 150),
                                )
                              );
                            },
                            child: Text('${widget.posts[index]['user']}', style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                          Text(
                            '${widget.posts[index]['content']}',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                            ),
                          )
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