import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/drawer.dart';
import 'package:hwn_mart/cart/order_stepper.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Cart {
  var productId, title, color, size, image, quantity, price, storeAddress;

  Cart({
    @required this.productId,
    @required this.title,
    @required this.color,
    @required this.size,
    @required this.image,
    @required this.quantity,
    @required this.price,
    @required this.storeAddress,
  });

  Map toJson() => {
        'productId': productId,
        'title': title,
        'color': color,
        'size': size,
        'image': image,
        'quantity': quantity,
        'price': price,
        'storeAddress': storeAddress
      };
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int size;
  var userId, deliveryCharges;
  var mycartList = [];
  double totalCost = 0;
  List<Cart> newCartJson = [];
  Widget checkStatement = CircularProgressIndicator();
  Future<List<CartModel>> _fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userID");
    if (userId == null) {
      setState(() {
        userId = prefs.getString("userID");
        checkStatement = Text("--You are not signed in--");
      });
      return [];
    } else {
      var response = await http.post(Uri.parse(cartUrl), body: {
        'id': userId,
      });
      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<CartModel> listOfUsers = items.map<CartModel>((json) {
          return CartModel.fromJson(json);
        }).toList();
        size = listOfUsers.length;

        if (mounted && size > 0) {
          setState(() {
            userId = prefs.getString("userID");
            mycartList = listOfUsers;
            totalCost =
                double.parse((items[items.length - 1]["totalCost"]).toString());
            deliveryCharges =
                (items[items.length - 1]["delivery_charges"]).toString();
          });
        } else {
          setState(() {
            userId = prefs.getString("userID");
            checkStatement = Text("--Your cart is empty--");
          });
        }
        return listOfUsers;
      } else {
        throw Exception('Failed to load internet');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  int quantity = 001;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          "Cart",
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0,
        toolbarHeight: 50,
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              color: primary,
              height: 3.0,
            ),
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              userId = prefs.getString("userID");
              if (userId == null) {
                myToast("You are not signed in");
              } else {
                await http.post(Uri.parse(dltCartUrl), body: {
                  "type": 'all',
                  "id": userId,
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              }
            },
            icon: Image.asset(
              "assets/slice/Vector Smart Object.png",
              width: 18,
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset(
              "assets/slice/rectangle.png",
              width: 22,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: userId == null || mycartList.isEmpty
            ? Center(child: checkStatement)
            : ListView.builder(
                itemCount: mycartList.length,
                itemBuilder: (context, index) {
                  double total = (double.parse(mycartList[index].price)) *
                      (mycartList[index].cquantity);
                  newCartJson.add(Cart(
                    productId: mycartList[index].pid,
                    title: mycartList[index].title,
                    color: mycartList[index].ccolor,
                    size: mycartList[index].csize,
                    image: mycartList[index].image,
                    quantity: mycartList[index].cquantity,
                    price: mycartList[index].price,
                    storeAddress: mycartList[index].storeAddress,
                  ));
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 100,
                                        width: 90,
                                        child: CachedNetworkImage(
                                          imageUrl: "$value/" +
                                              mycartList[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.62,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  mycartList[index].title,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${mycartList[index].availability}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                (mycartList[index].availability)
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "in stock"
                                                    ? Colors.green
                                                    : primary,
                                          ),
                                        ),
                                        mycartList[index].csize == '' ||
                                                mycartList[index].csize == null
                                            ? Container()
                                            : Text(
                                                "Size: " +
                                                    mycartList[index]
                                                        .csize
                                                        .toString(),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                        mycartList[index].ccolor == '' ||
                                                mycartList[index].ccolor == null
                                            ? Container()
                                            : Text(
                                                "Color: " +
                                                    mycartList[index]
                                                        .ccolor
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.62,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "Store Address: ${(mycartList[index].storeAddress)}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Rs.${(mycartList[index].price)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: primary,
                                          ),
                                        ),
                                        Text(
                                          "Total: Rs.${total.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    QuantityButton("-", () {
                                      if (mycartList[index].cquantity != 1) {
                                        newCartJson.clear();
                                        setState(() {
                                          totalCost = totalCost -
                                              double.parse(
                                                  mycartList[index].price);
                                          mycartList[index].cquantity--;
                                        });
                                      }
                                    }),
                                    Text(
                                      mycartList[index].cquantity.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600]),
                                    ),
                                    QuantityButton("+", () {
                                      newCartJson.clear();
                                      setState(() {
                                        totalCost = totalCost +
                                            double.parse(
                                                mycartList[index].price);

                                        mycartList[index].cquantity++;
                                      });
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 15,
                        child: InkWell(
                          onTap: () async {
                            print("cart id ${mycartList[index].cid}");
                            await http.post(Uri.parse(dltCartUrl), body: {
                              "id": mycartList[index].cid,
                              "type": 'one',
                            });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen()));
                          },
                          child: Image.asset(
                            "assets/slice/x.png",
                            width: 15,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      bottomNavigationBar: Container(
        color: primary,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: totalCost == null
                    ? Text(
                        "Total Amount Rs." + 0.toStringAsFixed(2),
                        style: TextStyle(fontSize: 17, color: white),
                      )
                    : Text(
                        "Total Amount Rs." + totalCost.toStringAsFixed(2),
                        style: TextStyle(fontSize: 17, color: white),
                      ),
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  primary: white,
                ),
                onPressed: () {
                  int countItem = 0;
                  if (size > 0) {
                    for (var i = 0; i < mycartList.length; i++) {
                      var findItem = mycartList[i].availability;
                      if (findItem.toString().toLowerCase() == 'out of stock') {
                        countItem = countItem + 1;
                      }
                    }

                    print("check $countItem");
                    if (countItem > 0) {
                      validation(
                          "Alert",
                          "You have one or more product which is not available right now",
                          context);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderStepperScreen(
                                  deliveryCharges, totalCost, newCartJson)));
                    }
                  } else {
                    myToast("Your cart is empty");
                  }
                },
                child: Text(
                  "Order Now",
                  style: TextStyle(color: black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
