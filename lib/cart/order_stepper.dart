import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hwn_mart/widgets/urls.dart';

class OrderStepperScreen extends StatefulWidget {
  final mydeliveryCharges, totalCost;
  final List newCartJson;
  OrderStepperScreen(this.mydeliveryCharges, this.totalCost, this.newCartJson);
  @override
  _OrderStepperScreenState createState() => _OrderStepperScreenState();
}

class _OrderStepperScreenState extends State<OrderStepperScreen> {
  int _currentStep = 0;
  List addressList = [];
  String deliveryCharges = '0', delivery;
  String address, pstcode, city;
  List<bool> addressSelected = List.filled(100, false);
  String email, userID, fname, lname, number;
  bool _isInAsyncCall = false;

  _getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    email = prefs.getString("email");
    fname = prefs.getString("fname");
    lname = prefs.getString("lname");
    number = prefs.getString("number");

    setState(() {
      userID = userID;
      email = email;
      fname = fname;
      lname = lname;
      number = number;
    });
  }

  Future<List<AddressModel>> _fetchAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    var response = await http.post(Uri.parse(fetchAddressUrl), body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<AddressModel> listOfUsers = items.map<AddressModel>((json) {
        return AddressModel.fromJson(json);
      }).toList();
      if (mounted) {
        setState(() {
          addressList = listOfUsers;
        });
      }
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    _fetchAddress();
    _getSharedPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          "Place Order",
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
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: black,
        progressIndicator: CircularProgressIndicator(),
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                physics: ScrollPhysics(),
                // physics: ClampingScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                // onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: Text('Delivery'),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: RadioButtonGroup(
                        labelStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 12),
                        labels: <String>[
                          "Cash on Delivery\n (Ground - 2 to 7 days)\n Note: It will charge you Rs.${widget.mydeliveryCharges}. \n",
                          "\n"
                              "\n"
                              "Self Delivery\n Note: You can pickup your parcel from \nrelative store. \n"
                        ],
                        onSelected: (String selected) {
                          print(selected);
                          if (selected ==
                              "Cash on Delivery\n (Ground - 2 to 7 days)\n Note: It will charge you Rs.${widget.mydeliveryCharges}. \n") {
                            delivery = "Cash on Delivery";
                            deliveryCharges = widget.mydeliveryCharges;
                          } else {
                            delivery = "Self Delivery";
                            deliveryCharges = '0';
                          }
                        },
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: Text('Address'),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.6, //300,
                      child: addressList == null ||
                              addressList.length == 0 ||
                              addressList == []
                          ? Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/addaddress");
                                },
                                child: Text(
                                  "Add Address",
                                  style: TextStyle(color: white),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: addressList.length,
                              itemBuilder: (context, index) {
                                final item = addressList[index];

                                return Card(
                                  child: ListTile(
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address:  ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              child: Text(item.address,
                                                  style: TextStyle(fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "City:  ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(item.city,
                                                style: TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Post code:  ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(item.postcode,
                                                style: TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.orange[300],
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  addressSelected =
                                                      List.filled(100, false);
                                                  addressSelected[index] = true;
                                                  address = item.address;
                                                  pstcode = item.postcode;
                                                  city = item.city;
                                                });
                                              },
                                              child: addressSelected[index]
                                                  ? Icon(Icons.check)
                                                  : Text(
                                                      "Select",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: Text('Confirm'),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.6,
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
                                              "$fname $lname",
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
                                              email,
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
                                              number,
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
                                        " (${delivery.toString()})",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                deliveryCharges == '0'
                                    ? Container()
                                    : Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Address:  ",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      "$address , $city",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
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
                              widget.newCartJson
                                  .map(
                                    (prod) => Card(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                    child: CachedNetworkImage(
                                                  imageUrl:
                                                      "$value/" + prod.image,
                                                  height: 50,
                                                  width: 50,
                                                )),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${prod.title}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      deliveryCharges == '0'
                                                          ? Text(
                                                              "${prod.storeAddress}",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                        prod.price.toString() +
                                                        " x " +
                                                        prod.quantity
                                                            .toString() +
                                                        "\n= Rs." +
                                                        "${((prod.quantity) * double.parse(prod.price)).toString()}",
                                                  ),
                                                ),
                                              ],
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
                                            horizontal: 10.0, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                              "Rs." +
                                                  widget.totalCost.toString(),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                              "Rs." +
                                                  deliveryCharges.toString(),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                              "Rs.${((widget.totalCost) + double.parse(deliveryCharges)).toStringAsFixed(1)}",
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {
    // _currentStep < 2 ? setState(() => _currentStep += 1) : null;
    if (_currentStep == 0) {
      if (delivery == null) {
        validation("Note:", "Please select an option", context);
      } else {
        if (delivery == "Cash on Delivery") {
          setState(() => _currentStep += 1);
        } else {
          setState(() => _currentStep += 2);
        }
      }
    } else if (_currentStep == 1) {
      if (address == null) {
        validation("Note:", "Please select your shipping address", context);
      } else {
        setState(() => _currentStep += 1);
      }
    } else if (_currentStep == 2) {
      var json =
          jsonEncode((widget.newCartJson).map((e) => e.toJson()).toList());
      print(json);

      setState(() {
        _isInAsyncCall = true;
      });
      var response = await http.post(Uri.parse(placeOrderUrl), body: {
        'userID': userID,
        'email': email,
        'fname': fname,
        'lname': lname,
        'number': number,
        'subTotal': widget.totalCost.toString(),
        'total':
            ((widget.totalCost) + double.parse(deliveryCharges)).toString(),
        'delivery': delivery.toString(),
        'deliveryCharges': deliveryCharges.toString(),
        'address': address == null ? '' : address,
        'city': city == null ? '' : city,
        'pstcode': pstcode == null ? '' : pstcode.toString(),
        'json': json.toString(),
      });

      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          _isInAsyncCall = false;
        });
        myToast("Congrats, Your order has been placed");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
        myToast("Something went wrong");
      }
    }
  }

  // cancel() {
  //   _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  // }
}
