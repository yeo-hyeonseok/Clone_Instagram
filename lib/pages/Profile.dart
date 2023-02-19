import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../store/store.dart' as store;
import '../components/ProfileHeader.dart';

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
      // 스크롤 바가 필요하다면 CustomScrollView
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: ProfileHeader(),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Image.network('${context.watch<store.Store1>().profileImages[index]}'),
                  childCount: context.watch<store.Store1>().profileImages.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            )
            // 그리드를 만들고 싶다면 GridView
            // 몇개의 그리드를 띄워야 할지 모르겠다면 GridView.builder
          ],
        ),
    );
  }
}



