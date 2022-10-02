import 'dart:convert';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hwn_mart/account/register/register_auth.dart';
import '../widgets/const.dart';
import '../widgets/urls.dart';
import '../widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterSc extends StatefulWidget {
  @override
  _RegisterScState createState() => _RegisterScState();
}

class _RegisterScState extends State<RegisterSc> {
  bool _isInAsyncCall = false;
  String fname, lname, email, number, pass, confirmpass;
  bool isSignIn = false;
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
        color: black,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SineupFormField(
                          TextFormField(
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
                      onChanged: (value) {
                        number = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: signupForm("Phone Number"),
                    ),
                    Color(0xFFeeeeee),
                  ),
                  SizedBox(height: 20),
                  SineupFormField(
                    TextFormField(
                      onChanged: (value) {
                        pass = value;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: signupForm("Password"),
                    ),
                    Color(0xFFeeeeee),
                  ),
                  SizedBox(height: 20),
                  SineupFormField(
                    TextFormField(
                      onChanged: (value) {
                        confirmpass = value;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: signupForm("Confirm Password"),
                    ),
                    Color(0xFFeeeeee),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: SignUpButton(() async {
                      if (fname == null ||
                          lname == null ||
                          email == null ||
                          number == null ||
                          pass == null ||
                          confirmpass == null) {
                        validation('Note:', "Please provide all the values..",
                            context);
                      } else if (fname.length <= 2 || lname.length <= 2) {
                        validation(
                            'Note:', "Please enter a valid name..", context);
                      } else if (EmailValidator.validate(email) == false) {
                        validation('Note:',
                            "Please enter a valid email address..", context);
                      } else if (int.tryParse(number) == null) {
                        validation('Note:',
                            "Please enter a valid Phone Number..", context);
                      } else if (pass != confirmpass) {
                        validation('Note:', "Password do not match..", context);
                      } else {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          print("$fname $lname $email $pass $confirmpass");
                          userRegistration();
                        } else {
                          validation(
                              'Failed:',
                              "Try again later or Check your network Connection..",
                              context);
                        }
                      }
                    }, "Register"),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Do you have account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/account', (Route<dynamic> route) => false);
                    },
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int random() {
    var rng = Random();
    int a;
    for (var i = 0; i < 10; i++) {
      a = rng.nextInt(1000000);
    }
    return a;
  }

  Future userRegistration() async {
    setState(() {
      _isInAsyncCall = true;
    });
    // Store all data with Param Name.
    var jsonData = {
      'fname': fname,
      'lname': lname,
      'email': email,
      'number': number,
      'pass': pass,
    };

    int randomNumber = random();
    var response = await http.post(Uri.parse(verifyRegisterEmailUrl), body: {
      "email": email,
      "key": randomNumber.toString(),
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data.length == 0) {
        validation(
            "Note:",
            "Something went wrong, Please contact with our Customer Service",
            context);
        setState(() {
          _isInAsyncCall = false;
        });
      } else {
        print(response.body);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterAuthPage(
                    email, randomNumber.toString(), jsonData)));
        setState(() {
          _isInAsyncCall = false;
        });
      }
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      validation(
          "Note:",
          "Something went wrong, Please contact with our Customer Service",
          context);
    }
  }
}
