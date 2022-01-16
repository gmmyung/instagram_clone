import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Store extends ChangeNotifier {
  var followers = [];
  var loadState = false;

  adduser() {
    followers.add({'follower': 0, 'followed': false});
    notifyListeners();
  }

  var profileImage = [];

  getProfileImage() async {
    if (loadState == false) {
      print('getprofile');
      http
          .get(Uri.parse('https://codingapple1.github.io/app/profile.json'))
          .then((result) {
        print(jsonDecode(result.body));
        profileImage = jsonDecode(result.body);
        notifyListeners();
      });
      loadState = true;
    }
  }

  initializeuser(i) {
    followers = [];
    for (int a = 0; a < i; a++) {
      followers.add({'follower': 0, 'followed': false});
    }
    notifyListeners();
  }

  followuser(i) {
    if (followers[i]['followed']) {
      if (followers[i]['follower'] == 1) {
        followers[i]['follower'] = -1;
      } else {
        followers[i]['follower'] = 1;
      }
    } else {
      followers[i]['follower']++;
      followers[i]['followed'] = true;
    }
    notifyListeners();
  }
}
