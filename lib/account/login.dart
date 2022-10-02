import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:hwn_mart/account/register.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, pass, type;
  bool _isInAsyncCall = false;
  Future<bool> _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("userID", userID);
    prefs.setString("fname", fname);
    prefs.setString("lname", lname);
    prefs.setString("number", number);
    prefs.setString("type", type);
    return true;
  }

  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfefefe),
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        toolbarHeight: 40,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        color: black,
        progressIndicator: CircularProgressIndicator(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: Form(
                child: Column(
                  children: [
                    MyFormField(
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: signForm(
                            "Email", Image.asset("assets/slice/user(1).png")),
                      ),
                      Color(0xFFfcfcfc),
                    ),
                    SizedBox(height: 20),
                    MyFormField(
                      TextFormField(
                        onChanged: (value) {
                          pass = value;
                        },
                        obscureText: _obscureText,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Password",
                          hintStyle: TextStyle(color: grey, fontSize: 14),
                          prefixIcon: Padding(
                              padding: EdgeInsets.all(14),
                              child: Image.asset("assets/slice/password.png")),
                          suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: _toggle),
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFfcfcfc)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      Color(0xFFfcfcfc),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(fontSize: 14, color: grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    SignUpButton(() async {
                      if (email == null || pass == null) {
                        validation('Note:', "Please provide all the values..",
                            context);
                      } else {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          login();
                        } else {
                          validation(
                              'Note:',
                              "Try again later or Check your network Connection..",
                              context);
                        }
                      }
                    }, "Login"),
                    SizedBox(height: 50),
                    Text(
                      "Don't have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterSc()));
                      },
                      child: Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  String userID, fname, lname, number;
  Future<void> login() async {
    setState(() {
      _isInAsyncCall = true;
    });
    print("login");
    final response = await http.post(Uri.parse(loginUrl), body: {
      "email": email,
      "password": pass,
    });
    print(response.body);
    var data = json.decode(response.body);
    if (data.length == 0) {
      validation("Note:", "Login Failed, Try Again..", context);
      setState(() {
        _isInAsyncCall = false;
      });
    } else {
      userID = data[0]["user_id"];
      fname = data[0]["first_name"];
      lname = data[0]["last_name"];
      number = data[0]["number"];
      type = 'other';
      print(userID);
      print(fname);
      _savePreference().then((bool committed) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/account', (Route<dynamic> route) => false);
        setState(() {
          _isInAsyncCall = false;
        });
      });
    }
  }
}
