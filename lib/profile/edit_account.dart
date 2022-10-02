import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool _isInAsyncCall = false;
  String fname, lname, email, numb;
  String userID, fprefs, lprefs, numberprefs, emailprefs;
  TextEditingController _fcontroller,
      _lcontroller,
      _emailcontroller,
      _numbcontroller;
  myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailprefs = prefs.getString('email');
    fprefs = prefs.getString('fname');
    lprefs = prefs.getString('lname');
    numberprefs = prefs.getString('number');
    setState(() {
      _fcontroller = new TextEditingController(text: fprefs);
      _lcontroller = new TextEditingController(text: lprefs);
      _emailcontroller = new TextEditingController(text: emailprefs);
      _numbcontroller = new TextEditingController(text: numberprefs);
      fname = fprefs;
      lname = lprefs;
      email = emailprefs;
      numb = numberprefs;
      print(fname + lname);
    });
  }

  @override
  void initState() {
    super.initState();
    myPrefs();
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
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Account",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf4511e)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text("Edit Account",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: SineupFormField(
                            TextFormField(
                              controller: _fcontroller,
                              onChanged: (value) {
                                fname = value;
                              },
                              keyboardType: TextInputType.text,
                              decoration: signupForm("First Name"),
                            ),
                            Color(0xFFeeeeee),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: SineupFormField(
                            TextFormField(
                              controller: _lcontroller,
                              onChanged: (value) {
                                lname = value;
                              },
                              keyboardType: TextInputType.text,
                              decoration: signupForm("Last Name"),
                            ),
                            Color(0xFFeeeeee),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SineupFormField(
                      TextFormField(
                        controller: _emailcontroller,
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: signupForm("Email Address"),
                      ),
                      Color(0xFFeeeeee),
                    ),
                    SizedBox(height: 20),
                    SineupFormField(
                      TextFormField(
                        controller: _numbcontroller,
                        onChanged: (value) {
                          numb = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: signupForm("Phone Number"),
                      ),
                      Color(0xFFeeeeee),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SignUpButton(() async {
                        if (fname == null ||
                            lname == null ||
                            email == null ||
                            numb == null) {
                          validation('Note:', "Please provide all the values..",
                              context);
                        } else if (fname.length <= 2 || lname.length <= 2) {
                          validation(
                              'Note:', "Please enter a valid name..", context);
                        } else if (EmailValidator.validate(email) == false) {
                          validation('Note:',
                              "Please enter a valid email address..", context);
                        } else if (int.tryParse(numb) == null) {
                          validation('Note:',
                              "Please enter a valid Phone Number..", context);
                        } else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            print("$fname $lname $email $numb ");
                            register();
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

  String f, l, e, n, i;
  register() async {
    setState(() {
      _isInAsyncCall = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getString('userID');
    print(userID);
    if (userID == null) {
      return null;
    } else {
      var response = await http.post(Uri.parse(editAccountUrl), body: {
        "id": userID,
        "first": fname,
        "last": lname,
        "number": numb,
      });
      if (response.statusCode == 200) {
        print(response.body);
        var data = json.decode(response.body);
        i = data[0]["user_id"];
        f = data[0]["first_name"];
        l = data[0]["last_name"];
        n = data[0]["number"];
        _savePreference().then((bool committed) {
          validation(
              'Note:', "Your account has been updated successfully.", context);
        });
        setState(() {
          _isInAsyncCall = false;
        });
      }
    }
  }

  Future<bool> _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userID", i);
    prefs.setString("fname", f);
    prefs.setString("lname", l);
    prefs.setString("number", n);
    print(prefs);
    return true;
  }
}
