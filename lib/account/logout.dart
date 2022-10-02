import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  final color;
  Logout(this.color);
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var email = prefs.getString('email');
        var userID = prefs.getString('userID');
        // var type = prefs.getString('type');
        print(email);
        if (email == null && userID == null) {
          return myToast("Something went wrong");
        } else {
          // if (type == 'gmail') {
          //   await Authentication.signOut(context);
          //   prefs.remove('email');
          //   prefs.remove('userID');
          //   prefs.remove("fname");
          //   prefs.remove("lname");
          //   prefs.remove("number");

          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //       '/account', (Route<dynamic> route) => false);
          // } else {
            prefs.remove('email');
            prefs.remove('userID');
            prefs.remove("fname");
            prefs.remove("lname");
            prefs.remove("number");

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/account', (Route<dynamic> route) => false);
          }
        // }
      },
      icon: Icon(
        Icons.exit_to_app,
        color: widget.color,
      ),
    );
  }
}
