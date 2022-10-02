import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hwn_mart/drawer/about.dart';
import 'package:hwn_mart/drawer/privacy.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String emails = "Please sign in to get access",
      fname = "Not",
      lname = "Signed In";

  Future<String> _data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emails = prefs.getString('email');
    fname = prefs.getString("fname");
    lname = prefs.getString("lname");
    if (emails == null || fname == null || lname == null) {
      setState(() {
        emails = "Please sign in to get access";
        fname = "Not";
        lname = "Signed In";
      });
    } else {
      setState(() {
        emails = emails;
        fname = fname;
        lname = lname;
      });
    }
    return emails;
  }

  @override
  void initState() {
    super.initState();
    _data();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[600],
            blurRadius: 30.0,
            spreadRadius: 10.0,
            offset: Offset(
              1.0,
              1.0,
            ),
          ),
        ],
      ),
      child: Drawer(
        child: Container(
          // color: Color(0xFFe4e4e4),
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 120,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fname,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        lname,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    emails,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 5,
                  color: primary,
                  thickness: 4,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/account', (Route<dynamic> route) => false);
                },
                title: Text("My HWN",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                leading: Image.asset(
                  "assets/slice/account.png",
                  width: 30,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUsScreen()));
                },
                title: Text("About us",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                leading: Image.asset(
                  "assets/slice/About.png",
                  width: 30,
                ),
              ),
              ExpansionTile(
                title: Text("Follow us",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                leading: Image.asset(
                  "assets/slice/rate.png",
                  width: 30,
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 37.0,
                        icon: Image.asset("assets/slice/fb.png", color: black),
                        onPressed: () async {
                          var fbUrl = "$facebookUrl";
                          await canLaunch(fbUrl)
                              ? launch(fbUrl)
                              : myToast("Failed to open link");
                        },
                      ),
                      IconButton(
                        iconSize: 38.0,
                        icon: Image.asset("assets/slice/in.png", color: black),
                        onPressed: () async {
                          var instaappUrl = "$minstagramUrl";
                          await canLaunch(instaappUrl)
                              ? launch(instaappUrl)
                              : myToast("Failed to launch url");
                        },
                      ),
                    ],
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Contact us",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                leading: Image.asset(
                  "assets/slice/contact.png",
                  width: 30,
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 36.0,
                        icon:
                            Image.asset("assets/slice/wapp.png", color: black),
                        onPressed: () async {
                          var whatsappUrl = "whatsapp://send?phone=$cwatsapUrl";
                          await canLaunch(whatsappUrl)
                              ? launch(whatsappUrl)
                              : myToast("There is no whatsapp installed");
                        },
                      ),
                      IconButton(
                        iconSize: 37.0,
                        icon: Image.asset("assets/slice/fb.png", color: black),
                        onPressed: () async {
                          var fbUrl = "$facebookUrl";
                          await canLaunch(fbUrl)
                              ? launch(fbUrl)
                              : myToast("Failed to open link");
                        },
                      ),
                      IconButton(
                        iconSize: 38.0,
                        icon: Image.asset("assets/slice/in.png", color: black),
                        onPressed: () async {
                          var instaappUrl = "$minstagramUrl";
                          await canLaunch(instaappUrl)
                              ? launch(instaappUrl)
                              : myToast("Failed to launch url");
                        },
                      ),
                      IconButton(
                        iconSize: 38.0,
                        icon:
                            Image.asset("assets/slice/email.png", color: black),
                        onPressed: () async {
                          final Uri params = Uri(
                            scheme: 'mailto',
                            path: '$cgmailUrl',
                          );
                          String url = params.toString();
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            myToast('Could not launch $url');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyScreen()));
                },
                title: Text("Privacy policy",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                leading: Image.asset(
                  "assets/slice/privacypolicy.png",
                  width: 30,
                ),
              ),
              ListTile(
                onTap: () async {
                  if (Platform.isIOS) {
                    var url = 'https://www.apple.com/app-store/';
                    await canLaunch(url)
                        ? await launch(url)
                        : myToast("Something went wrong");
                  } else {
                    await canLaunch(giveReviews)
                        ? await launch(giveReviews)
                        : myToast("Something went wrong");
                  }
                },
                title: Text("Rate us",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                leading: Image.asset(
                  "assets/slice/rate.png",
                  width: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
