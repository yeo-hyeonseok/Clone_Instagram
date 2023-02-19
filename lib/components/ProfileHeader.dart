import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/store.dart' as store;

class ProfileHeader extends StatelessWidget {
  ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 60, height: 60,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ),
        Text('팔로워 ${context.watch<store.Store1>().follower}명', style: TextStyle(
            fontSize: 16
        ),),
        ElevatedButton(onPressed: (){
          context.read<store.Store1>().setIsFollowing();
          context.read<store.Store1>().setFollower();
        }, child: Text(context.watch<store.Store1>().isFollowing ? '팔로잉' : '팔로우'))
      ],
    );
  }
}