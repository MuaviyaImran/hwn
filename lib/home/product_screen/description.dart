import 'package:flutter/material.dart';
import 'package:hwn_mart/widgets/const.dart';

class DescriptionScreen extends StatelessWidget {
  final desc, deliveryChagres;
  DescriptionScreen(this.desc, this.deliveryChagres);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$desc",
            softWrap: true,
            style: TextStyle(fontSize: 16),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Column(
          //       children: [
          //         Image.asset("assets/images/fastdelivery.png", width: 80),
          //         Text(
          //           "Fast Delivery",
          //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          //         ),
          //         Text(
          //           "2-7 Days",
          //           style: TextStyle(color: grey, fontWeight: FontWeight.w300),
          //         )
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         Image.asset("assets/images/bestprice.png", width: 80),
          //         Text(
          //           "Best Price",
          //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          //         ),
          //         Text(
          //           "Guarented",
          //           style: TextStyle(
          //               color: Colors.grey, fontWeight: FontWeight.w300),
          //         )
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         Image.asset("assets/images/delivercharges.png", width: 80),
          //         Text(
          //           "Delivery Charges",
          //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          //         ),
          //         Text(
          //           "Rs.$deliveryChagres",
          //           style: TextStyle(color: grey, fontWeight: FontWeight.w300),
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}
