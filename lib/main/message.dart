import 'package:flutter/material.dart';
import 'package:hwn_mart/widgets/const.dart';
import 'package:hwn_mart/widgets/urls.dart';
import 'package:hwn_mart/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        titleSpacing: 0,
        title: Text(
          "Contact",
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0,
        toolbarHeight: 50,
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              color: white,
              height: 3.0,
            ),
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        actions: [],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/slice/background.png",
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/slice/Vector Smart Object3.png",
                width: 220,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "If you want to Advertise your Business so Feel Free",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: white,
                    ),
                  ),
                  Text(
                    "Contact us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Just click and type us",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 38.0,
                        icon: Image.asset("assets/slice/wapp.png"),
                        onPressed: () async {
                          var whatsappUrl = "whatsapp://send?phone=$mwatsapUrl";
                          await canLaunch(whatsappUrl)
                              ? launch(whatsappUrl)
                              : myToast("There is no whatsapp installed");
                        },
                      ),
                      IconButton(
                        iconSize: 39.0,
                        icon: Image.asset("assets/slice/fb.png"),
                        onPressed: () async {
                          var fbUrl = "$facebookUrl";
                          await canLaunch(fbUrl)
                              ? launch(fbUrl)
                              : myToast("Failed to open link");
                        },
                      ),
                      IconButton(
                        iconSize: 40.0,
                        icon: Image.asset("assets/slice/in.png"),
                        onPressed: () async {
                          var instaappUrl = "$minstagramUrl";
                          await canLaunch(instaappUrl)
                              ? launch(instaappUrl)
                              : myToast("Failed to launch url");
                        },
                      ),
                      IconButton(
                        iconSize: 40.0,
                        icon: Image.asset("assets/slice/email.png"),
                        onPressed: () async {
                          final Uri params = Uri(
                            scheme: 'mailto',
                            path: '$mgmailUrl',
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
            ],
          )
        ],
      ),
    );
  }
}
