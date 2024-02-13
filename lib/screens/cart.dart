import 'package:example/constants/text.dart';
import 'package:example/provider/cartProvider.dart';
import 'package:example/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Cart extends StatelessWidget with ChangeNotifier {
  Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          color: Colors.white,
          child: Column(children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyHomePage())),
                    child: const Icon(
                      Icons.navigate_before,
                      color: Colors.black,
                      size: 24,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Cart',
                  style: kHeadingtext,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Consumer<CartItems>(builder: (context, cart, child) {
              print(cart.items.length);

              return Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    scrollDirection: Axis.vertical,
                    itemCount: cart.items.length,
                    itemBuilder: ((context, index) {
                      var data = cart.items[index];
                      return Container(
                        height: 100,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 199, 199, 199),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(data.image),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    maxLines: 2,
                                    text: TextSpan(
                                      text: data.title,
                                      style: kCartText,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Rs ${data.price.toString()}',
                                        style: kPricetext,
                                      ),
                                      GestureDetector(
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        onTap: () {
                                          cart.deleteProduct(data);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Total",
                  style: kHeadingtext,
                ),
                Consumer<CartItems>(
                    builder: (context, value, child) => Text(
                          "Rs ${value.price}",
                          style: kPricetext.copyWith(fontSize: 16),
                        )),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
