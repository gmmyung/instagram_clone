import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'dart:io';

var _refreshNum = 1;

getPost() async {
  var result =
      await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
  if (result.statusCode == 200) {
    _refreshNum = 1;
    return jsonDecode(result.body);
  }
}

morePost() async {
  var result = await http.get(
      Uri.parse('https://codingapple1.github.io/app/more${_refreshNum}.json'));
  if (result.statusCode == 200) {
    print(result.body);
    _refreshNum++;
    return jsonDecode(result.body);
  } else {
    return null;
  }
}

class Home extends StatefulWidget {
  const Home(
      {Key? key,
      this.posts,
      this.refreshHandler,
      this.addHandler,
      this.refreshcontroller})
      : super(key: key);
  final posts;
  final refreshHandler;
  final addHandler;
  final refreshcontroller;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (widget.posts.isNotEmpty) {
      return SmartRefresher(
        header: const ClassicHeader(
          completeDuration: Duration(milliseconds: 100),
          releaseText: '',
          refreshingText: '',
          completeText: '',
          idleText: '',
        ),
        footer: const ClassicFooter(
          idleText: '',
          failedText: '',
          loadingText: '',
          canLoadingText: '',
        ),
        enablePullDown: true,
        enablePullUp: true,
        controller: widget.refreshcontroller,
        onRefresh: widget.refreshHandler,
        onLoading: widget.addHandler,
        child: ListView.builder(
            controller: scrollController,
            itemCount: widget.posts.length,
            itemBuilder: (context, i) {
              return PostWidget(
                  image: imageLoader(widget.posts[i]),
                  author: widget.posts[i]['user'],
                  likes: widget.posts[i]['likes'],
                  content: widget.posts[i]['content']);
            }),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

imageLoader(post) {
  print(post['local']);
  if (post['local'] == true) {
    print(post['image']);
    return Image.file(post['image']);
  } else {
    return Image.network(post['image']);
  }
}

class PostWidget extends StatefulWidget {
  PostWidget({Key? key, this.image, this.likes, this.author, this.content})
      : super(key: key);
  Image? image;
  String? author;
  String? content;
  int? likes;
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 0, 12),
          child: SizedBox(
              width: 150,
              child: Text(
                widget.author ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              )),
        ),
        widget.image ?? Image.asset('assets/images/no_image.jpg'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 4, 8),
                child: Icon(Icons.favorite_border),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Icon(Icons.chat_bubble_outline),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: Icon(Icons.send_outlined),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 4, 8),
                child: Icon(Icons.bookmark_border_outlined),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 0, 12),
          child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  text: widget.likes.toString(),
                  children: <TextSpan>[
                TextSpan(
                    text: '명이 좋아합니다',
                    style: Theme.of(context).textTheme.bodyText2)
              ])),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 12),
          child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  text: widget.author,
                  children: <TextSpan>[
                TextSpan(
                    text: ' ' + (widget.content ?? ''),
                    style: Theme.of(context).textTheme.bodyText2)
              ])),
        ),
      ],
    );
  }
}
