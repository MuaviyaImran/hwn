import 'package:flutter/material.dart';
import '../order_history_extend.dart';

class CompletedTab extends StatefulWidget {
  final List orderList;
  CompletedTab(this.orderList);

  @override
  _CompletedTabState createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: widget.orderList
            .map(
              (order) => order.status.toString().toLowerCase() != 'completed'
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
                                  Text(
                                    order.status,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[600],
                                    ),
                                  )
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
