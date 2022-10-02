import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email, name1 = '', name2, number, utype;
  _myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var e = prefs.getString('email');
    var n1 = prefs.getString('fname');
    var n2 = prefs.getString('lname');
    var numb = prefs.getString('number');
    var ty = prefs.getString('type');
    setState(() {
      email = e;
      name1 = n1;
      name2 = n2;
      number = numb;
      utype = ty;
    });
  }

  @override
  void initState() {
    super.initState();
    _myPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar:
          ProfileTopBar().getAppBar("${name1.toUpperCase()}", primary, context),
      body: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/slice/background.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Image.asset(
                  "assets/slice/Vector Smart Object3.png",
                  fit: BoxFit.cover,
                  height: 140,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ProfileButton(Icons.person, "EDIT ACCOUNT", () {
                  Navigator.pushNamed(context, "/editaccount");
                }),
              ],
            ),
          ),
          utype == 'gmail'
              ? Container()
              : Expanded(
                  child: Row(
                    children: [
                      ProfileButton(Icons.lock, "EDIT PASSWORD", () {
                        Navigator.pushNamed(context, "/editpassword");
                      }),
                    ],
                  ),
                ),
          Expanded(
            child: Row(
              children: [
                ProfileButton(Icons.home, "My Address", () {
                  Navigator.pushNamed(context, '/showaddress');
                }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ProfileButton(Icons.history, "ORDER HISTORY", () {
                  Navigator.pushNamed(context, "/orderHistory");
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final IconData icn;
  final String name;
  final Function onPress;
  ProfileButton(this.icn, this.name, this.onPress);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: InkWell(
          onTap: onPress,
          child: Container(
            width: 100,
            height: 100,
            color: white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  icn,
                  color: primary,
                  size: 38,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  name,
                  style: TextStyle(color: primary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
