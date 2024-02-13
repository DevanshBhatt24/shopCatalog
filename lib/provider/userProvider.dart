import 'package:flutter/cupertino.dart';

class User extends ChangeNotifier {
  Map<String, String> userDetails = {"username": "username", "email": "email"};

  void setUser(String username, String email) {
    print("add");
    userDetails['username'] = username;
    userDetails['email'] = email;
    notifyListeners();
  }

  void deleteUser() {
    userDetails['username'] = "";
    userDetails['email'] = "";
    notifyListeners();
  }
}
