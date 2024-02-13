import 'dart:convert';

import 'package:example/constants/text.dart';
import 'package:example/provider/userProvider.dart';
import 'package:example/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;
  User? _user;
  @override
  void initState() {
    // TODO: implement initState
    _user = Provider.of<User>(context, listen: false);
    super.initState();
  }

  void signin() async {
    // FirebaseAuth _auth = FirebaseAuth.instance;
    if (!_formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {"email": email, "password": password};
    var url = Uri.parse(
        "https://0531-2401-4900-1f3a-6a50-61b0-3e44-8383-b9df.ngrok-free.app/user/login");
    var res = await http.post(url, body: data);
    print(res.body);
    var extractedData = jsonDecode(res.body);
    setState(() {
      isLoading = false;
    });
    if (extractedData['message'] == 'Login successful') {
      // Provider.of<UserProvider>(context, listen: false).setUser();
      sharedPreferences.setString("token", extractedData['token']);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${extractedData['message']}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: !isLoading
          ? SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                child: Column(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(top: 16),
                    //   width: 150,
                    //   height: 150,
                    //   child: logoimage,
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Enter Your Details",
                      style: kHeadingtext,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Please verify with your email and \n type in your password",
                      style: klightText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) => email = value,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email is required";
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Enter your email",
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff8965b8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff8569b8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: const Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, right: 20),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.4))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onChanged: (value) => password = value,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password is required";
                              }
                              if (value.length < 6) {
                                return 'Password must have at least 6 character';
                              }
                              return null;
                            },
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff8965b8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff8569b8)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Enter your password",
                                prefixIcon: Container(
                                  margin: EdgeInsets.fromLTRB(18, 0, 24, 0),
                                  child: const Icon(
                                    Icons.lock_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.4))),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          GestureDetector(
                            onTap: signin,
                            child: Container(
                              alignment: Alignment.center,
                              width: 314,
                              height: 51,
                              decoration: const BoxDecoration(
                                  color: Color(0xff8965b8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Text("SIgn In", style: kbuttontext),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 230.0),
                    //   child: splashShape1,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 50.0),
                    //   child: splashShape2,
                    // )
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            )),
    );
  }
}
