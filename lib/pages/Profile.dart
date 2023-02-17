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
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            context.read<Store1>().setName('차차무식');
          }, child: Text("버튼")),
        ],
      ),
    );
  }
}
