import 'dart:convert';

import 'package:example/components/nearbyres.dart';
import 'package:example/constants/text.dart';
import 'package:example/model/product.dart';
import 'package:example/provider/cartProvider.dart';
import 'package:example/provider/userProvider.dart';
import 'package:example/screens/cart.dart';
import 'package:example/screens/login.dart';
import 'package:example/service/productsData.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> dummyData = [];
  ProductData _api = ProductData();
  bool isLoading = false;
  CartItems? cartItems;

  @override
  void initState() {
    // TODO: implement initState
    cartItems = Provider.of<CartItems>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    getData();
    super.initState();
  }

  void getData() async {
    final res = await _api.getAllProducts();
    print(cartItems!.items);
    for (final data in res) {
      for (final innerdata in cartItems!.items) {
        if (data.id == innerdata.id) {
          setState(() {
            data.isOnCart = true;
          });
        }
      }
    }
    print(res.length);
    setState(() {
      dummyData = res;
      isLoading = false;
    });
  }

  signout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token')!;
    Map<String, String>? data = {'auth-token': token};
    print(data);
    sharedPreferences.clear();
    var url = Uri.parse(
      "https://0531-2401-4900-1f3a-6a50-61b0-3e44-8383-b9df.ngrok-free.app/user/logout",
    );
    var res = await http.post(url, headers: data);
    print(res.body);

    var extractedData = jsonDecode(res.body);
    if (extractedData['message'] == 'Logout successful') {
      sharedPreferences.clear();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${extractedData['message']}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(actions: [
          Consumer<CartItems>(
            builder: (context, cart, child) => badges.Badge(
              position: badges.BadgePosition.topEnd(top: 3, end: 18),
              badgeAnimation: const badges.BadgeAnimation.slide(
                // animationDuration: Duration(seconds: 1),
                loopAnimation: false,
                disappearanceFadeAnimationDuration: Duration(milliseconds: 500),
                curve: Curves.easeInCubic,
              ),
              showBadge: cart.itemcount() == 0 ? false : true,
              badgeContent: Text(
                '${cart.itemcount()}',
                style: kCartItemsText,
              ),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  padding: EdgeInsets.only(right: 30.0),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Cart()));
                  }),
            ),
          )
        ]),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("All Products",
                style: kHeadingtext.copyWith(fontWeight: FontWeight.w300)),
          ),
          const SizedBox(
            height: 20,
          ),
          !isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1 / 1.7),
                      shrinkWrap: true,
                      itemCount: 20,
                      scrollDirection: Axis.vertical,
                      itemBuilder: ((context, index) {
                        return !dummyData.isEmpty
                            ? Column(
                                children: [
                                  ProductCard(
                                    title: dummyData[index].title,
                                    description: dummyData[index].description,
                                    image: dummyData[index].image,
                                    price: dummyData[index].price,
                                  ),
                                  InkWell(
                                    onTap: () => !dummyData[index].isOnCart
                                        ? {
                                            cartItems!
                                                .addProduct(dummyData[index]),
                                            cartItems!.addPrice(
                                                dummyData[index].price),
                                            setState(() {
                                              dummyData[index].isOnCart = true;
                                            })
                                          }
                                        : Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => Cart())),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                        border: dummyData[index].isOnCart
                                            ? Border.all(
                                                color: Colors.cyan, width: 2)
                                            : Border.all(color: Colors.cyan),
                                        color: dummyData[index].isOnCart
                                            ? Colors.white
                                            : Colors.cyan,
                                      ),
                                      child: Center(
                                          child: Text(
                                        !dummyData[index].isOnCart
                                            ? "ADD TO CART"
                                            : "GO TO CART",
                                        style: kbuttontext.copyWith(
                                            color: dummyData[index].isOnCart
                                                ? Colors.cyan
                                                : Colors.white),
                                      )),
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                "No Products To show",
                                style: klightText,
                              );
                      })),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
        ]),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                ),
                child: Consumer<User>(
                  builder: (context, user, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.userDetails['username'] ?? 'Unknown',
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      Text(user.userDetails['email'] ?? 'Unknown',
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
              ListTile(
                trailing: IconButton(
                  onPressed: () => signout(),
                  icon: Icon(Icons.logout),
                  color: Colors.red,
                ),
                title: Text('LogOut'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
