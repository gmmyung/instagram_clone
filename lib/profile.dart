import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'store.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  Profile({Key? key, required this.i}) : super(key: key);
  final int i;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body:
            //FollowProfile(i: i, context: context),
            CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: FollowProfile(i: i, context: context)),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (c, i) =>
                      Image.network(context.watch<Store>().profileImage[i]),
                  childCount: context.watch<Store>().profileImage.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
            ),
          ],
        ));
  }
}

class FollowProfile extends StatefulWidget {
  const FollowProfile({Key? key, required this.i, required this.context})
      : super(key: key);

  final int i;
  final BuildContext context;

  @override
  State<FollowProfile> createState() => _FollowProfileState();
}

class _FollowProfileState extends State<FollowProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<Store>(context, listen: false).getProfileImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: context.watch<Store>().loadState
                ? NetworkImage(
                    context.watch<Store>().profileImage[widget.i % 6])
                : (const AssetImage('assets/images/no_image.jpg'))
                    as ImageProvider),
        Text(
            "${context.watch<Store>().followers[widget.i]['follower']} followers"),
        ElevatedButton(
            onPressed: () {
              context.read<Store>().followuser(widget.i);
            },
            child: const Text("Follow"))
      ]),
    );
  }
}
