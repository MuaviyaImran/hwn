import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../widgets/const.dart';
import '../widgets/urls.dart';
import '../widgets/widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final String email;
  ResetPassword(this.email);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isInAsyncCall = false;
  String pass, confirmPass;

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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/logo.png",
              ),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(white.withOpacity(0.7), BlendMode.dstATop),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: black),
                        ),
                      ),
                      MyFormField(
                        TextFormField(
                          onChanged: (value) {
                            pass = value;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: signForm("New Password",
                              Image.asset("assets/slice/password.png")),
                        ),
                        Color(0xFFfcfcfc),
                      ),
                      SizedBox(height: 20),
                      MyFormField(
                        TextFormField(
                          onChanged: (value) {
                            confirmPass = value;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: signForm("Confirm Password",
                              Image.asset("assets/slice/password.png")),
                        ),
                        Color(0xFFfcfcfc),
                      ),
                      SizedBox(height: 40),
                      SignUpButton(() async {
                        if (pass == null || confirmPass == null) {
                          validation('Note:', "Please provide all the values..",
                              context);
                        } else if (pass.length <= 2 ||
                            confirmPass.length <= 2) {
                          validation('Note:', "Please enter a length of > 2..",
                              context);
                        } else if (pass != confirmPass) {
                          validation(
                              'Note:', "Passwords do not match..", context);
                        } else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            print(" $pass");
                            resetPass();
                          } else {
                            validation(
                                'Failed:',
                                "Try again later or Check your network Connection..",
                                context);
                          }
                        }
                      }, "Update"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  resetPass() async {
    setState(() {
      _isInAsyncCall = true;
    });

    var response = await http.post(Uri.parse(resetPassUrl), body: {
      "email": widget.email,
      "pass": pass,
    });
    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/account', (Route<dynamic> route) => false);
      myToast("Password Reset, Please login!");
      setState(() {
        _isInAsyncCall = false;
      });
    } else {
      validation("Note", "Something went wrong", context);
    }
  }
}
