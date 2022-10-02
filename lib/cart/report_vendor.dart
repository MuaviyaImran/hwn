import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';

class ReportTheVendor extends StatefulWidget {
  final String userID, firstname, lastname, orderdetailid;
  ReportTheVendor(
      this.userID, this.firstname, this.lastname, this.orderdetailid);
  @override
  _ReportTheVendorState createState() => _ReportTheVendorState();
}

class _ReportTheVendorState extends State<ReportTheVendor> {
  bool _isInAsyncCall = false;
  String name, dropdownValue, comment;
  TextEditingController _controller;
  myPrefs() async {
    setState(() {
      _controller = new TextEditingController(
          text: widget.firstname + " " + widget.lastname);
      name = widget.firstname + " " + widget.lastname;
      print(name);
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
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 45,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.6,
        color: black,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
          child: Form(
            child: Column(
              children: <Widget>[
                Text(
                  "Help",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primary),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SineupFormField(
                    // 45,
                    TextFormField(
                      readOnly: true,
                      controller: _controller,
                      onChanged: (value) {
                        name = value;
                      },
                      keyboardType: TextInputType.text,
                      decoration: signupForm("Your Name"),
                    ),
                    Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFfcfcfc),
                    border: Border.all(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    hint: Text(
                      "--SELECT--",
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        print(dropdownValue);
                      });
                    },
                    items: <String>[
                      'My item hasn\'nt arrived on time',
                      'I have received a damaged item',
                      'I want to return my item',
                      'I want to cancle my order',
                      'I didn\'t received my parcel yet',
                      'Our worker use abusive or vulgar language',
                      'You have received a false address information(for self delivery only)',
                      'Others',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color(0xFFfcfcfc),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    maxLines: 4,
                    onChanged: (value) {
                      comment = value;
                    },
                    keyboardType: TextInputType.text,
                    decoration: signupForm("Write a message.."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SignUpButton(() async {
                    if (name == null ||
                        comment == null ||
                        dropdownValue == null) {
                      validation(
                          'Note:', "Please provide all the values..", context);
                    } else if (comment.length <= 2) {
                      validation(
                          'Note:', "Please enter a valid data..", context);
                    } else {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        print("$name $comment");
                        needHelp();
                      } else {
                        validation(
                            'Failed:',
                            "Try again later or Check your network Connection..",
                            context);
                      }
                    }
                  }, "Send"),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "We will try our best to solve your problem, this may take some time.",
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  needHelp() async {
    setState(() {
      _isInAsyncCall = true;
    });

    var response = await http.post(Uri.parse(reportUrl), body: {
      "id": widget.userID.toString(),
      "name": name,
      "orderId": widget.orderdetailid,
      "title": dropdownValue,
      "comment": comment,
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      myToast(
          "Your message has been sent successfully, we will get back to you soon");
      setState(() {
        _isInAsyncCall = false;
      });
    }
  }
}
