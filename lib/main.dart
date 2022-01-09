import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'materialTheme.dart' as my_theme;
import 'post.dart';
import 'upload.dart';

void main() {
  runApp(MaterialApp(
    home: const MyApp(),
    theme: my_theme.materialAppLightTheme(),
    darkTheme: my_theme.materialAppDarkTheme(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tabState = 0; // 0 -> home, 1 -> shop
  var posts = [];
  var refreshController = RefreshController(initialRefresh: false);
  File? userImage;

  getpost() async {
    var result = await getPost();
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      posts = [];
      posts = result;
    });

    print('refreshpost');
    refreshController.refreshCompleted();
    refreshController.loadComplete();
  }

  morepost() async {
    var result = await morePost();
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      if (result != null) posts.add(result);
    });
    print('morepost');
    if (result == null) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
  }

  addpost(post) async {
    setState(() {
      posts.add(post);
    });
  }

  @override
  void initState() {
    refreshController = RefreshController(initialRefresh: false);
    super.initState();
    getpost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: SvgPicture.asset('assets/images/instagram.svg',
              height: 40,
              color: Theme.of(context).appBarTheme.iconTheme!.color),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      var picker = ImagePicker();
                      var image =
                          await picker.pickImage(source: ImageSource.gallery);
                      print(image);
                      setState(() {
                        if (image != null) {
                          print(image.path);
                          userImage = File(image.path);
                        } else {
                          userImage = null;
                        }
                      });
                      if (userImage == null) {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) =>
                                Upload(image: userImage, uploadMethod: addpost),
                          ));
                    }))
          ],
        ),
        body: [
          Home(
              posts: posts,
              refreshHandler: getpost,
              addHandler: morepost,
              refreshcontroller: refreshController),
          const Text('shop')
        ][tabState],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1))),
          child: BottomNavigationBar(
            currentIndex: tabState,
            onTap: (i) {
              setState(() {
                tabState = i;
              });
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'home',
                  activeIcon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: 'shop',
                  activeIcon: Icon(Icons.shopping_bag))
            ],
          ),
        ));
  }
}
