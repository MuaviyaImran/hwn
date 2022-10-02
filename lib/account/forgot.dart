import 'dart:convert';
import 'dart:math';
import 'package:hwn_mart/widgets/const.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'authenticate.dart';
import '../widgets/urls.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        color: black,
        progressIndicator: CircularProgressIndicator(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(
              //       "assets/images/logo.png",
              //     ),
              //     fit: BoxFit.cover,
              //     colorFilter: ColorFilter.mode(
              //         Colors.white.withOpacity(0.7), BlendMode.dstATop),
              //   ),
              // ),
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: 220,
                          ),
                        ),
                        Text(
                          "Forgot Your Password?",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
                          child: Text(
                            "Enter your mail below to receive your password reset instructions",
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Form(
                          child: MyFormField(
                            TextFormField(
                              onChanged: (value) {
                                email = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: signForm("Email Address",
                                  Image.asset("assets/slice/user(1).png")),
                            ),
                            Color(0xFFfcfcfc),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SignUpButton(
                            () async {
                              if (email == null) {
                                validation('Note:', "Please enter the Email..",
                                    context);
                              } else {
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult ==
                                        ConnectivityResult.mobile ||
                                    connectivityResult ==
                                        ConnectivityResult.wifi) {
                                  _verifyEmail();
                                } else {
                                  validation(
                                      'Failed:',
                                      "Try again later or Check your network Connection..",
                                      context);
                                }
                              }
                            },
                            "Submit",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  bool _isInAsyncCall = false;
  _verifyEmail() async {
    setState(() {
      _isInAsyncCall = true;
    });
    int randomNumber = random();
    var response = await http.post(Uri.parse(verifyEmailUrl), body: {
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
                builder: (context) =>
                    AuthnticationPage(email, randomNumber.toString())));
        setState(() {
          _isInAsyncCall = false;
        });
      }
    }
  }
}
