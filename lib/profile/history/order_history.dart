import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hwn_mart/account/logout.dart';
import 'package:hwn_mart/profile/history/tabs/cancled.dart';
import 'package:hwn_mart/profile/history/tabs/completed.dart';
import 'package:hwn_mart/profile/history/tabs/pendings.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hwn_mart/widgets/model.dart';
import 'package:hwn_mart/widgets/urls.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int size;
  var userID;
  List orderList = [];
  Future<List<HistoryModel>> _fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID');
    var response = await http.post(Uri.parse(orderHistoryUrl), body: {
      "id": userID,
    });
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<HistoryModel> listOfUsers = items.map<HistoryModel>((json) {
        return HistoryModel.fromJson(json);
      }).toList();
      size = listOfUsers.length;
      if (mounted) {
        setState(() {
          orderList = listOfUsers;
        });
      }
      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: 'Pendings'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancled'),
            ],
          ),
          centerTitle: true,
          titleSpacing: 0,
          title: Text(
            "Orders",
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            Logout(white),
          ],
        ),
        body: TabBarView(
          children: [
            PendingsTab(orderList),
            CompletedTab(orderList),
            CanceledTab(orderList),
          ],
        ),
      ),
    );
  }
}
