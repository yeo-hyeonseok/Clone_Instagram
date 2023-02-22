import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// firebase에서 데이터베이스 이용하는 방법
final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  void getData() async {
    // future를 다루는 코드를 예외처리 하고 싶으면 try catch 문 쓰셈
    try{
      /* 특정 document를 가져오고 싶다면 */
      //var result = await firestore.collection('product').doc('document 아이디').get();

      /* 해당 컬렉션에 있는 모든 document 가져오기 (list) */
      var result = await firestore.collection('product').get();

      /* 특정 조건에 따라 데이터를 가져오고 싶다면 where문 추가하셈 */
      //var result = await firestore.collection('product').where(조건).get();

      /* 특정 document를 삭제하고 싶다면 */
      //await firestore.collection('product').doc('ofV8bLGlwZ3iCMngugFz').delete();

      /* 특정 document를 수정하고 싶다면 */
      await firestore.collection('product').doc('z50SevnOadDOpamvvjSi').update(
          {'name': '수정된 품목'});

      for(var doc in result.docs) {
        print(doc['name']);
      }

      // firestore에 데이터 저장하는 방법임
      //await firestore.collection('product').add({'name':'내복', 'price':4000});
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      ],
    );
  }
}