import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/cart/report_vendor.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:hwn_mart/cart/write_review.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:http/http.dart' as http;
import 'package:hwn_mart/widgets/model.dart';

class OrderHistoryExtend extends StatefulWidget {
  final String orderId,
      status,
      first,
      last,
      email,
      number,
      subCost,
      totalCost,
      address,
      city,
      delivery,
      deliveryCharges,
      date;
  OrderHistoryExtend(
      this.orderId,
      this.status,
      this.first,
      this.last,
      this.email,
      this.number,
      this.subCost,
      this.totalCost,
      this.address,
      this.city,
      this.delivery,
      this.deliveryCharges,
      this.date);
  @override
  _OrderHistoryExtendState createState() => _OrderHistoryExtendState();
}

class _OrderHistoryExtendState extends State<OrderHistoryExtend> {
  var userID;
  Future<List<HistoryDetailModel>> _fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    if (userID == null) {
      return null;
    } else {
      var response = await http.post(Uri.parse(orderHistoryDetailUrl), body: {
        "id": widget.orderId,
      });
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<HistoryDetailModel> listOfUsers =
            items.map<HistoryDetailModel>((json) {
          return HistoryDetailModel.fromJson(json);
        }).toList();

        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileTopBar().getAppBar("", primary, context),
      body: FutureBuilder<List<HistoryDetailModel>>(
        future: _fetchCart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Container(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Order Detail",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name:  ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${widget.first} ${widget.last}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Email:  ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.email}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Phone:  ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.number,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Shipping Address",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                            Text(
                              " (${widget.delivery.toString()})",
                              style: TextStyle(
                                fontSize: 14,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.deliveryCharges == '0'
                          ? Container()
                          : Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Address:  ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "${widget.address} , ${widget.city}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Items",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    snapshot.data
                        .map(
                          (prod) => Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Container(
                                                height: 300,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "$value/" + prod.image,
                                                  height: 300,
                                                  width: 300,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: "$value/" + prod.image,
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${prod.title}",
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "SKU: ${prod.sku}",
                                              softWrap: true,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            widget.deliveryCharges == '0'
                                                ? Text(
                                                    "${prod.storeAddress}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Rs." +
                                              prod.price +
                                              " x " +
                                              prod.quantity +
                                              "\n= Rs." +
                                              prod.total,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: prod.rating == '0' ||
                                          prod.rating == null
                                      ? Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.orange[300],
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              ReportTheVendor(
                                                                userID,
                                                                widget.first,
                                                                widget.last,
                                                                prod.orderdetailid,
                                                              ))));
                                                },
                                                child: Text(
                                                  "Need Help",
                                                  style: TextStyle(
                                                    color: white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                child: widget.status ==
                                                        "Completed"
                                                    ? ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Colors.blue[300],
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: ((context) => WritReview(
                                                                      userID,
                                                                      widget
                                                                          .first,
                                                                      widget
                                                                          .last,
                                                                      prod.orderdetailid,
                                                                      prod.pId))));
                                                        },
                                                        child: Text(
                                                          "Give Reviews",
                                                          style: TextStyle(
                                                            color: white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text("(" + prod.rating + ")  "),
                                              SmoothStarRating(
                                                allowHalfRating: true,
                                                starCount: 5,
                                                rating:
                                                    double.parse(prod.rating),
                                                size: 22.0,
                                                color: Colors.yellow[700],
                                                borderColor: Colors.yellow[600],
                                                spacing: 0.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2.0),
                              child: Container(
                                width: 200,
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "SubTotal:  ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Rs." + widget.subCost,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Shipping Charges:  ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Rs." + widget.deliveryCharges.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2.0),
                              child: Container(
                                width: 200,
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Total Cost:  ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF22548a),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Rs." + widget.totalCost,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF22548a),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.green[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
