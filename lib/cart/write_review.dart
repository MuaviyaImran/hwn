import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class WritReview extends StatefulWidget {
  final String userID, firstname, lastname, orderdetailid, prodId;
  WritReview(this.userID, this.firstname, this.lastname, this.orderdetailid,
      this.prodId);
  @override
  _WritReviewState createState() => _WritReviewState();
}

class _WritReviewState extends State<WritReview> {
  double rating = 0.0;
  bool _isInAsyncCall = false;
  String name, comment;
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
                  "Write A Review",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: primary),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SmoothStarRating(
                      allowHalfRating: true,
                      onRated: (v) {
                        rating = v;
                        setState(() {});
                      },
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      color: Colors.yellow[700],
                      borderColor: Colors.yellow[600],
                      spacing: 0.0),
                ),
                Text(
                  "Rating  " + rating.toString(),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                MyFormField(
                  TextFormField(
                    readOnly: true,
                    controller: _controller,
                    onChanged: (value) {
                      name = value;
                    },
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                    decoration: signupForm("Your Name"),
                  ),
                  Color.fromRGBO(255, 255, 255, 0.4),
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
                    decoration: signupForm("Write a comment.."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SignUpButton(() async {
                    if (name == null || comment == null || rating == 0.0) {
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
                        writeReview();
                      } else {
                        validation(
                            'Failed:',
                            "Try again later or Check your network Connection..",
                            context);
                      }
                    }
                  }, "Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  writeReview() async {
    setState(() {
      _isInAsyncCall = true;
    });

    var response = await http.post(Uri.parse(writeReviewUrl), body: {
      "id": widget.userID.toString(),
      "orderId": widget.orderdetailid.toString(),
      "prodId": widget.prodId.toString(),
      "name": name,
      "comment": comment,
      "rating": rating.toString()
    });
    if (response.statusCode == 200) {
      myToast("Thank you for your reviews, This matters a lot for us");
      Navigator.pop(context);
      setState(() {
        _isInAsyncCall = false;
      });
      rating = 0;
    }
  }
}
