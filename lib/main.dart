import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
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

  getpost() async {
    var result = await getPost();
    setState(() {
      posts = [];
      posts = result;
    });
  }

  morepost() async {
    var result = await morePost();

    setState(() {
      if (result != null) posts.add(result);
    });
  }

  @override
  void initState() {
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const Upload(),
                          ));
                    }))
          ],
        ),
        body: [
          Home(posts: posts, refreshHandler: getpost, addHandler: morepost),
          Text('shop')
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
