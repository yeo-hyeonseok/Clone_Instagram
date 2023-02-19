import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/store.dart' as store;

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<store.Store1>().getProfileImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: Text(context.watch<store.Store2>().name),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Row(
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
            )
          ],
        ),
      ),
    );
  }
}
