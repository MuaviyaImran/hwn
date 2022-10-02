import 'package:flutter/material.dart';
import 'package:hwn_mart/account/logout.dart';
import 'package:hwn_mart/bars/searchBar.dart';
import 'package:hwn_mart/widgets/const.dart';

class TopBar {
  getAppBar(context) {
    return AppBar(
      backgroundColor: transparent,
      // toolbarHeight: 45,
      centerTitle: true,
      title: SearchBarSc(),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/wishlist");
          },
          icon: Image.asset(
            "assets/slice/Heart.png",
            width: 24,
          ),
        ),
      ],
      titleSpacing: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Image.asset(
            "assets/slice/rectangle.png",
            width: 22,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }
}

class OtherTopBar {
  getAppBar(title, context) {
    return AppBar(
      backgroundColor: transparent,
      centerTitle: true,
      titleSpacing: 0,
      title: Text(
        "$title",
        style: TextStyle(
          color: black,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevation: 0,
      toolbarHeight: 50,
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            color: primary,
            height: 3.0,
          ),
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/search");
          },
          icon: Image.asset(
            "assets/slice/Search in black.png",
            width: 18,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/wishlist");
          },
          icon: Image.asset(
            "assets/slice/Heart.png",
            width: 24,
          ),
        ),
      ],
    );
  }
}

class ProfileTopBar {
  getAppBar(title, color, context) {
    return AppBar(
      backgroundColor: color,
      centerTitle: true,
      titleSpacing: 0,
      title: Text(
        "$title",
        style: TextStyle(
          color: color == primary ? white : black,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevation: 0,
      toolbarHeight: 50,
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            color: primary,
            height: 3.0,
          ),
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
      actions: [
        Logout(color == primary ? white : grey),
      ],
    );
  }
}

class DrawerTopBar {
  getAppBar(title, context) {
    return AppBar(
      backgroundColor: transparent,
      centerTitle: true,
      titleSpacing: 0,
      title: Text(
        "$title",
        style: TextStyle(
          color: black,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevation: 0,
      toolbarHeight: 50,
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            color: primary,
            height: 3.0,
          ),
        ),
        preferredSize: Size.fromHeight(4.0),
      ),
    );
  }
}
