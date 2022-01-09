import 'package:flutter/material.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key, this.image, this.uploadMethod}) : super(key: key);
  final uploadMethod;
  final image;
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String? userName = null;
  String? content = null;

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
                  child: Image.file(widget.image)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  TextFieldPadding,
                  TextField(
                      onChanged: (input) {
                        setState(() {
                          userName = input;
                        });
                      },
                      cursorColor: Theme.of(context).iconTheme.color,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          focusedBorder: TextFieldBorder(
                              Theme.of(context).iconTheme.color),
                          labelText: 'User',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          enabledBorder: TextFieldBorder(
                              Theme.of(context).iconTheme.color),
                          floatingLabelBehavior: FloatingLabelBehavior.always)),
                  TextFieldPadding,
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
                          focusedBorder: TextFieldBorder(
                              Theme.of(context).iconTheme.color),
                          labelText: 'Content',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          enabledBorder: TextFieldBorder(
                              Theme.of(context).iconTheme.color),
                          floatingLabelBehavior: FloatingLabelBehavior.always)),
                  TextFieldPadding,
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
                      child: SizedBox(
                        child: Text('Upload'),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}

var TextFieldPadding = SizedBox(height: 30);

TextFieldBorder(color) {
  return OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: color),
      borderRadius: BorderRadius.all(Radius.circular(20)));
}
