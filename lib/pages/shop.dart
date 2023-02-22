import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
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

  void userRegister() async {
    try{
      // 회원가입하기
      var result = await auth.createUserWithEmailAndPassword(email: 'seok@test.com', password: '123456');

      // 회원사입 시 사용자의 이름도 함께 등록하고 싶다면
      result.user?.updateDisplayName('차무식');
      print(result.user);
    } catch(e) {
      print(e);
    }
  }

  // 로그인하기
  void userLogin() async {
    try{
      await auth.signInWithEmailAndPassword(email: 'seok@test.com', password: '123456');
    } catch(e) {
      print(e);
    }

    // uid는 사용자의 고유한 아이디값임, 얘로 구별하면 됨
    if(auth.currentUser?.uid == null) {
      print('현재 로그인 안하심');
    } else {
      print('현재 로그인 하심');
    }
  }

  void userLogout() async {
    await auth.signOut();
    // uid는 사용자의 고유한 아이디값임, 얘로 구별하면 됨
    if(auth.currentUser?.uid == null) {
      print('현재 로그인 안하심');
    } else {
      print('현재 로그인 하심');
    }
  }

  @override
  void initState() {
    super.initState();
    //userRegister();
    userLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      ],
    );
  }
}