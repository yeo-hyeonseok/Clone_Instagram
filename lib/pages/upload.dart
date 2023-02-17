import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  Upload({Key? key, this.galleryImage, this.addPost, this.postId}) : super(key: key);

  final galleryImage;
  final addPost;
  final postId;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  var textValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('게시글 작성하기'),
        actions: [
          IconButton(onPressed: (){
            widget.addPost({
              "id": widget.postId,
              "image": widget.galleryImage,
              "likes": 0,
              "date": DateTime.now(),
              "content": textValue.text,
              "user": '차무식'
            });
            Navigator.pop(context);
          }, icon: Icon(Icons.send, color: Colors.black, size: 28,))
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
              child: Image.file(widget.galleryImage, width: double.infinity, height: 200, fit: BoxFit.cover,),
            ),
            TextField(
              controller: textValue,
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
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('취소',
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