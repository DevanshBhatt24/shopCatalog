import 'package:example/provider/cartProvider.dart';
import 'package:example/provider/userProvider.dart';
import 'package:example/screens/homescreen.dart';
import 'package:example/screens/login.dart';
import 'package:example/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? isUser = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('token'));
  if (prefs.getString('token') != null) {
    await prefs.setBool("User", true);
    isUser = await prefs.getBool("User");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CartItems>(
            create: (_) => CartItems(),
          ),
          ChangeNotifierProvider<User>(create: (_) => User()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            home: isUser! ? MyHomePage() : SignUP()));
  }
}
