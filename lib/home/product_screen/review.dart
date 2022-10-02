import 'package:flutter/material.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewScreen extends StatefulWidget {
  final List<RatingModel> productReview;
  ReviewScreen(this.productReview);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Image.asset(
          //   "images/BG.png",
          //   fit: BoxFit.fill,
          // ),
          // Column(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.only(top: 8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: <Widget>[
          // SmoothStarRating(
          //     allowHalfRating: true,
          //     starCount: 5,
          //     rating: double.parse(rati),
          //     size: 22.0,
          //     color: Colors.yellow[700],
          //     borderColor: Colors.yellow[600],
          //     spacing: 0.0),
          // Text("  " + totalRate, style: TextStyle(fontSize: 16)),
          // Text(
          //   " (" + totalReview + " Reviews)",
          //   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          // ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              // color: Colors.grey[100],
              child: widget.productReview.isEmpty
                  ? Center(
                      child: Text("--No reviews yet--"),
                    )
                  : ListView(
                      children: widget.productReview
                          .map(
                            (review) => review.name == null
                                ? Container()
                                : Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(review.name,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            SmoothStarRating(
                                                allowHalfRating: true,
                                                starCount: 5,
                                                rating:
                                                    double.parse(review.rating),
                                                size: 20.0,
                                                color: Colors.yellow[700],
                                                borderColor: Colors.yellow[600],
                                                spacing: 0.0),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                  child: Text(review.comment))
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              review.date,
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Divider(
                                            thickness: 2,
                                            color: Colors.grey[200],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          )
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
