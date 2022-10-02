import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  bool _isInAsyncCall = false;
  String pass, confirm;
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
                      child: Text("Password",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SineupFormField(
                        TextFormField(
                          obscureText: true,
                          onChanged: (value) {
                            pass = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: signupForm("New Password"),
                        ),
                        Color(0xFFeeeeee),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SineupFormField(
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          confirm = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: signupForm("Confirm Password"),
                      ),
                      Color(0xFFeeeeee),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SignUpButton(() async {
                        if (pass == null) {
                          validation(
                              'Note:', "Please enter a password..", context);
                        } else if (pass.length < 2 || pass != confirm) {
                          validation(
                              'Note:', "Password do not match..", context);
                        } else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            print("$pass $confirm");
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

  register() async {
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
      var response = await http.post(Uri.parse(editPasswordUrl), body: {
        "id": userID,
        "pass": pass,
      });
      if (response.statusCode == 200) {
        validation(
            'Note:', "Your password has been updated successfully.", context);
        setState(() {
          _isInAsyncCall = false;
        });
      }
    }
  }
}
