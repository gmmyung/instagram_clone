import 'dart:io' as io;

import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key, this.image, this.uploadMethod}) : super(key: key);
  final uploadMethod;
  final image;
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String? userName;
  String? content;

  @override
  Widget build(BuildContext context) {
    print(widget.image);
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text('Upload')
              ],
            )),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor,
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ]),
                  child: Image.file(io.File(widget.image))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  textFieldPadding,
                  TextField(
                      onChanged: (input) {
                        setState(() {
                          userName = input;
                        });
                      },
                      cursorColor: Theme.of(context).iconTheme.color,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          focusedBorder: textFieldBorder(
                              Theme.of(context).iconTheme.color),
                          labelText: 'User',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          enabledBorder: textFieldBorder(
                              Theme.of(context).iconTheme.color),
                          floatingLabelBehavior: FloatingLabelBehavior.always)),
                  textFieldPadding,
                  TextField(
                      onChanged: (input) {
                        setState(() {
                          content = input;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Theme.of(context).iconTheme.color,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          focusedBorder: textFieldBorder(
                              Theme.of(context).iconTheme.color),
                          labelText: 'Content',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          enabledBorder: textFieldBorder(
                              Theme.of(context).iconTheme.color),
                          floatingLabelBehavior: FloatingLabelBehavior.always)),
                  textFieldPadding,
                  TextButton(
                      onPressed: () {
                        widget.uploadMethod({
                          'user': userName,
                          'content': content,
                          'image': widget.image,
                          'likes': 0,
                          'date': 'Jan 1',
                          'liked': false,
                          'local': true
                        });
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        child: Text('Upload'),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}

var textFieldPadding = SizedBox(height: 30);

OutlineInputBorder textFieldBorder(color) {
  return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: color),
      borderRadius: const BorderRadius.all(Radius.circular(20)));
}
