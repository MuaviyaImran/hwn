import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/bottom_tab.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterAuthPage extends StatefulWidget {
  final String email, uniqueId;
  final jsonData;
  RegisterAuthPage(this.email, this.uniqueId, this.jsonData);
  @override
  _RegisterAuthPageState createState() => _RegisterAuthPageState();
}

class _RegisterAuthPageState extends State<RegisterAuthPage> {
  final formKey = new GlobalKey<FormState>();
  bool _isInAsyncCall = false;
  String verificationId;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  var astrick = '';
  @override
  void initState() {
    super.initState();
    var a = widget.email.length;
    var b = widget.email.substring(0, 4);
    var ast = '';
    for (var i = 0; i < a - 4; i++) {
      ast += '*';
    }
    setState(() {
      astrick = b + ast;
    });
    print(astrick);
  }

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
        color: black,
        opacity: 0.7,
        progressIndicator: CircularProgressIndicator(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Please enter the ',
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'verification code',
                                      style: TextStyle(
                                        color: black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' sent to your email: \n\n $astrick',
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 2.0, right: 2.0, bottom: 20, top: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            getPinField(key: "1", focusNode: focusNode1),
                            SizedBox(width: 5.0),
                            getPinField(key: "2", focusNode: focusNode2),
                            SizedBox(width: 5.0),
                            getPinField(key: "3", focusNode: focusNode3),
                            SizedBox(width: 5.0),
                            getPinField(key: "4", focusNode: focusNode4),
                            SizedBox(width: 5.0),
                            getPinField(key: "5", focusNode: focusNode5),
                            SizedBox(width: 5.0),
                            getPinField(key: "6", focusNode: focusNode6),
                            SizedBox(width: 5.0),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SignUpButton(
                          () async {
                            if (code == widget.uniqueId) {
                              setState(() {
                                _isInAsyncCall = true;
                              });
                              // myToast("Congratulations, please login");
                              var response = await http.post(
                                  Uri.parse(registerUrl),
                                  body: json.encode(widget.jsonData));
                              var message = jsonDecode(response.body);
                              if (response.statusCode == 200) {
                                setState(() {
                                  _isInAsyncCall = false;
                                });
                                if (message ==
                                    "Email Already Exist, Please Try With a New Email or Login") {
                                  validation("Note", message, context);
                                } else {
                                  setState(() {
                                    _isInAsyncCall = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(3)));
                                  validation("Note", message, context);
                                }
                              } else {
                                validation(
                                    "Note:",
                                    "Something went wrong, Please contact with our Customer Service",
                                    context);
                              }
                            } else {
                              myToast("Something went wrong,Try again");
                              Navigator.pop(context);
                            }
                          },
                          "Verify",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
          autofocus: key.contains("1") ? true : false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          textAlign: TextAlign.center,
          cursorColor: black,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: black),
        ),
      );
}
