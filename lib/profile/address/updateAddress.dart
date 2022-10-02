import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/profile/address/show_address.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateAddress extends StatefulWidget {
  final String addressid, address, city, postcode;
  UpdateAddress(
    this.addressid,
    this.address,
    this.city,
    this.postcode,
  );
  @override
  _UpdateAddressState createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  bool _isInAsyncCall = false;
  String addr, ct, pstcd;
  TextEditingController _addcontroller, _ctcontroller, _pstcdcontroller;

  myAddress() async {
    setState(() {
      _addcontroller = new TextEditingController(text: widget.address);
      _ctcontroller = new TextEditingController(text: widget.city);
      _pstcdcontroller = new TextEditingController(text: widget.postcode);

      addr = widget.address;
      ct = widget.city;
      pstcd = widget.postcode;
    });
  }

  @override
  void initState() {
    myAddress();
    super.initState();
  }

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
                      child: Text("Update Address",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    SizedBox(height: 20),
                    MyFormField(
                      TextFormField(
                        controller: _addcontroller,
                        onChanged: (value) {
                          addr = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: signupForm("Address1*"),
                      ),
                      Color.fromRGBO(255, 255, 255, 0.4),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: MyFormField(
                            TextFormField(
                              controller: _ctcontroller,
                              onChanged: (value) {
                                ct = value;
                              },
                              keyboardType: TextInputType.text,
                              decoration: signupForm("city*"),
                            ),
                            Color(0xFFeeeeee),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: MyFormField(
                            TextFormField(
                              controller: _pstcdcontroller,
                              onChanged: (value) {
                                pstcd = value;
                              },
                              keyboardType: TextInputType.number,
                              decoration: signupForm("Postal Code*"),
                            ),
                            Color(0xFFeeeeee),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SignUpButton(() async {
                        if (addr == null || ct == null || pstcd == null) {
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
                      }, "Update"),
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
    if (email == null && userID == null) {
      return null;
    } else {
      var response = await http.post(Uri.parse(updateAddressurl), body: {
        "id": userID,
        "addressId": widget.addressid,
        "address": addr,
        "city": ct,
        "code": pstcd,
      });
      if (response.statusCode == 200) {
        myToast("Address has been updated");
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
