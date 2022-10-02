import 'package:flutter/material.dart';
import 'package:hwn_mart/widgets/const.dart';

class SearchBarSc extends StatefulWidget {
  @override
  _SearchBarScState createState() => _SearchBarScState();
}

class _SearchBarScState extends State<SearchBarSc> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/search");
      },
      child: Container(
        height: 37,
        decoration: BoxDecoration(
          color: Color(0xFFfcfcfc),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 0.4),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextFormField(
          enabled: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search categories / stores / product",
            prefixIcon: Icon(Icons.search, size: 22),
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary),
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }
}
