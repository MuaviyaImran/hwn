import 'package:flutter/material.dart';
import '../order_history_extend.dart';

class CanceledTab extends StatefulWidget {
  final List orderList;
  CanceledTab(this.orderList);

  @override
  _CanceledTabState createState() => _CanceledTabState();
}

class _CanceledTabState extends State<CanceledTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.orderList
            .map(
              (order) => order.status.toString().toLowerCase() != 'canceled' 
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                // border: Border(
                                //   top: BorderSide(
                                //     width: 2.0,
                                //     color: primary,
                                //   ),
                                // ),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\#00" + order.orderId,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  OrderHistoryExtend(
                                                      order.orderId,
                                                      order.status,
                                                      order.first,
                                                      order.last,
                                                      order.email,
                                                      order.number,
                                                      order.subCost,
                                                      order.totalCost,
                                                      order.address,
                                                      order.city,
                                                      order.delivery,
                                                      order.deliveryCharges,
                                                      order.date))));
                                    },
                                    icon: Icon(Icons.keyboard_arrow_right),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name:  ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    order.first + " " + order.last,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order Date:  ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    order.date,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status:  ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Container(
                                    child: order.status == "Complete"
                                        ? Text(
                                            order.status,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[600],
                                            ),
                                          )
                                        : Text(
                                            order.status,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[600],
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total:  ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    "Rs." + order.totalCost,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            )
            .toList(),
      ),
    );
  }
}
