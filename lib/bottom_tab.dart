import 'package:flutter/material.dart';
import 'package:hwn_mart/account/login.dart';
import 'package:hwn_mart/main/cart.dart';
import 'package:hwn_mart/main/message.dart';
import 'package:hwn_mart/main/home.dart';
import 'package:hwn_mart/main/profile.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  final currentIindex;
  MyHomePage(this.currentIindex);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  static var user;

  final List<Widget> page = [
    HomeScreen(),
    CartScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    myPrefs();
    currentIndex = widget.currentIindex;
  }

  myPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('userID');
    });
    print("user is $user");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 3
          ? user == null
              ? LoginScreen()
              : ProfileScreen()
          : page[currentIndex],
      bottomNavigationBar: Container(
        height: 52,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                currentIndex == 0
                    ? "assets/slice/Home btn fil.png"
                    : "assets/slice/Home btn with out ifl.png",
                width: 28,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                currentIndex == 1
                    ? "assets/slice/cart btn fil.png"
                    : "assets/slice/cart with out fil.png",
                width: 26,
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                currentIndex == 2
                    ? "assets/slice/Message icon fil.png"
                    : "assets/slice/Message icon without fil.png",
                width: 26,
              ),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                currentIndex == 3
                    ? "assets/slice/wallet fil.png"
                    : "assets/slice/wallet without fil.png",
                width: 20,
              ),
              label: 'My HWN',
            ),
          ],
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
