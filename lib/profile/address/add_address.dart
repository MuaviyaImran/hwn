import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/profile/address/show_address.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  bool _isInAsyncCall = false;
  String address, city, code;
  TextEditingController _fcontroller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileTopBar().getAppBar("", primary, context),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30),
              child: Form(
                child: Column(
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf4511e)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text("Add Address",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    SizedBox(height: 20),
                    SineupFormField(
                      TextFormField(
                        controller: _fcontroller,
                        onChanged: (value) {
                          address = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: signupForm("Address"),
                      ),
                      Color(0xFFeeeeee),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SineupFormField(
                            TextFormField(
                              controller: _fcontroller,
                              onChanged: (value) {
                                city = value;
                              },
                              keyboardType: TextInputType.text,
                              decoration: signupForm("City"),
                            ),
                            Color(0xFFeeeeee),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SineupFormField(
                            TextFormField(
                              controller: _fcontroller,
                              onChanged: (value) {
                                code = value;
                              },
                              keyboardType: TextInputType.number,
                              decoration: signupForm("Postal Code"),
                            ),
                            Color(0xFFeeeeee),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SignUpButton(() async {
                        if (address == null || city == null || code == null) {
                          validation('Note:', "Please provide all the values..",
                              context);
                        } else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            adress();
                          } else {
                            validation(
                                'Failed:',
                                "Try again later or Check your network Connection..",
                                context);
                          }
                        }
                      }, "Add"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  adress() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var userID = prefs.getString('userID');
    print(userID);
    var response;
    if (email == null && userID == null) {
      return null;
    } else {
      response = await http.post(Uri.parse(addAddressUrl), body: {
        "id": userID,
        "address": address,
        "city": city,
        "code": code,
      });
      if (response.statusCode == 200) {
        myToast("New has been added");
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ShowAddress()));
        setState(() {
          _isInAsyncCall = false;
        });
      }
    }
  }
}
