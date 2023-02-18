import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/store.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store1>().name),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset('assets/images/profile.jpg', width: 60, height: 60, fit: BoxFit.cover,),
                ),
                Text('팔로워 ${context.watch<Store1>().follower}명', style: TextStyle(
                  fontSize: 16
                ),),
                ElevatedButton(onPressed: (){
                  context.read<Store1>().setIsFollowing();
                  context.read<Store1>().setFollower();
                }, child: Text(context.watch<Store1>().isFollowing ? '팔로잉' : '팔로우'))
              ],
            )
          ],
        ),
      ),
    );
  }
}