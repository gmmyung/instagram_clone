import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'materialTheme.dart' as my_theme;
import 'post.dart';
import 'upload.dart';
import 'store.dart';
import 'package:provider/provider.dart';
import 'notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (c) => Store(),
    child: MaterialApp(
      home: MyApp(),
      theme: my_theme.materialAppLightTheme(),
      darkTheme: my_theme.materialAppDarkTheme(),
    ),
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
  var debugposts = [];
  var refreshController = RefreshController(initialRefresh: false);
  String? userImage;

  saveData(post) async {
    var storage = await SharedPreferences.getInstance();
    List<String> postlist = [];
    for (int i = 0; i < posts.length; i++) {
      postlist.add(jsonEncode(posts[i]));
    }
    await storage.setStringList('posts', postlist);
    setState(() {
      debugposts = postlist;
    });
  }

  getData() async {
    var storage = await SharedPreferences.getInstance();
    List<String> postfile = storage.getStringList('posts') ?? [];
    var postlist = [];
    for (var p in postfile) {
      postlist.add(jsonDecode(p));
    }
    return postlist;
  }

  getpost({initialize: false}) async {
    var result = await getPost(initialize: initialize);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      if (initialize == false) {
        posts = result;
      }
      if (posts.isEmpty) {
        posts = result;
      }
    });

    //print('refreshpost');
    refreshController.refreshCompleted();
    refreshController.loadComplete();
    saveData(posts);
    context.read<Store>().initializeuser(posts.length);
  }

  morepost() async {
    var result = await morePost();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      if (result != null) {
        posts.add(result);
        context.read<Store>().adduser();
      }
    });
    if (result == null) {
      refreshController.loadNoData();
    } else {
      refreshController.loadComplete();
    }
    saveData(posts);
  }

  addpost(post) async {
    setState(() {
      post['id'] = posts.length;
      posts.add(post);
      context.read<Store>().adduser();
    });

    print(post);
    saveData(posts);
  }

  initialData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    var postlist = await getData() ?? [];
    setState(() {
      posts = postlist;
    });
    setState(() {
      debugposts = posts;
    });
    await getpost(initialize: true);
    context.read<Store>().initializeuser(posts.length);
    print(context.read<Store>().followers);
  }

  @override
  void initState() {
    refreshController = RefreshController(initialRefresh: false);
    super.initState();
    initialData();
    initNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text('+'),
          onPressed: () {
            showNotification2();
          },
        ),
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
                      setState(() {
                        if (image != null) {
                          userImage = image.path;
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
          Text(debugposts.toString())
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
