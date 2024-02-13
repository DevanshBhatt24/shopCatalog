import 'dart:convert';

import 'package:example/constants/text.dart';
import 'package:example/screens/homescreen.dart';
import 'package:example/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? username;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void signUp() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map data = {"email": email, "password": password, "username": username};
    var url = Uri.parse(
        "https://0531-2401-4900-1f3a-6a50-61b0-3e44-8383-b9df.ngrok-free.app/user/register");
    var res = await http.post(url, body: data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var extractedData = jsonDecode(res.body);
    setState(() {
      isLoading = false;
    });
    if (extractedData['message'] == 'Register successful') {
      // Provider.of<UserProvider>(context, listen: false).setUser();
      prefs.setString("token", extractedData['token']);
      setState(() {
        isLoading = false;
      });
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Register",
                      style: kHeadingtext,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Enter your personal information",
                      style: klightText,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) => username = value,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Username is required";
                              }

                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                counterStyle: TextStyle(fontSize: 5),
                                hintText: "Enter your name",
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff8965b8)),
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
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.4))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                counterStyle: TextStyle(fontSize: 5),
                                hintText: "Enter your email",
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff8965b8)),
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
                            height: 20,
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
                            onTap: signUp,
                            child: Container(
                              alignment: Alignment.center,
                              width: 314,
                              height: 51,
                              decoration: const BoxDecoration(
                                  color: Color(0xff8965b8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Text("Sign Up", style: kbuttontext),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: klightText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (cxt) => const Login()));
                          },
                          child: Text(
                            'Sign In',
                            style: kSmallBoldText.copyWith(fontSize: 13),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 90,
                    ),
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
