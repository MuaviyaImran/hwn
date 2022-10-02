import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/profile/address/updateAddress.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShowAddress extends StatefulWidget {
  @override
  _ShowAddressState createState() => _ShowAddressState();
}

class _ShowAddressState extends State<ShowAddress> {
  int size;
  var userID;
  Future<List<AddressModel>> _fetchAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(Uri.parse(fetchAddressUrl), body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<AddressModel> listOfUsers = items.map<AddressModel>((json) {
        return AddressModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileTopBar().getAppBar("", primary, context),
      body: FutureBuilder<List<AddressModel>>(
        future: _fetchAddress(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (size == 0) {
            return Center(child: Text("--You haven't added any address yet--"));
          }
          return Container(
            // padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: snapshot.data
                  .map(
                    (address) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Address:  ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(address.address,
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "City:  ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(address.city,
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Post code:  ",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(address.postcode,
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green[300],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateAddress(
                                                address.id,
                                                address.address,
                                                address.city,
                                                address.postcode,
                                              )));
                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red[300],
                                ),
                                onPressed: () async {
                                  var response = await http
                                      .post(Uri.parse(deleteAddressUrl), body: {
                                    "id": address.id,
                                    "type": 'address',
                                  });
                                  if (response.statusCode == 200) {
                                    myToast("Address deleted");
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShowAddress()));
                                  } else {
                                    myToast("Something went wrong");
                                  }
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        width: 50,
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Text(""),
            ),
            Expanded(
              flex: 4,
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
          ],
        ),
      ),
    );
  }
}
