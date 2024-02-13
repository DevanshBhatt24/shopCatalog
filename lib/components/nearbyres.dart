import 'package:example/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String description;
  final String title;
  final dynamic price;
  const ProductCard(
      {required this.description,
      required this.image,
      required this.price,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 164, 164, 164),
                blurRadius: 15,
                offset: Offset(0, 8))
          ]),
      // alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Image.network(image)),
          const SizedBox(
            height: 16,
          ),
          RichText(
              maxLines: 2,
              text: TextSpan(
                text: title,
                style: kHeadingtext.copyWith(fontSize: 14),
              )),
          const SizedBox(
            height: 16,
          ),
          Text("Rs ${price.toString()}", style: kPricetext),
        ],
      ),
    );
  }
}
