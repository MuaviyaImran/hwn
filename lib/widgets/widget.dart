import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/const.dart';

//==================== FORM ===============================//
class MyFormField extends StatelessWidget {
  final Widget formfield;
  final Color color;
  MyFormField(this.formfield, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xFFfcfcfc),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFe8e8e8),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: formfield,
    );
  }
}

class SineupFormField extends StatelessWidget {
  final Widget formfield;
  final Color color;
  SineupFormField(this.formfield, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Color(0xFFfcfcfc),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFe8e8e8),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: formfield,
    );
  }
}

signForm(String nm, ic) {
  return InputDecoration(
    isDense: true,
    hintText: nm,
    hintStyle: TextStyle(color: grey, fontSize: 14),
    prefixIcon: Padding(padding: EdgeInsets.all(14), child: ic),
    contentPadding: EdgeInsets.all(15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFfcfcfc)),
      borderRadius: BorderRadius.circular(12.0),
    ),
  );
}

signupForm(String nm) {
  return InputDecoration(
    isDense: true,
    hintText: nm,
    hintStyle: TextStyle(color: grey, fontSize: 14),
    contentPadding: EdgeInsets.all(15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFfcfcfc)),
      borderRadius: BorderRadius.circular(12.0),
    ),
  );
}

//////////////////  DIALOG BOX  ////////////
void validation(String title, String text, context) {
  String tit = title;
  String txt = text;
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              backgroundColor: white,
              contentPadding: EdgeInsets.fromLTRB(24.0, 5.0, 24.0, 5.0),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              title: Text(
                tit,
                style: TextStyle(color: Color(0xff183132)),
              ),
              content: Text(
                txt,
                style: TextStyle(color: Color(0xff183132)),
              ),
              actions: <Widget>[
                MyFlatButton(() {
                  Navigator.of(context).pop();
                }, 'OK', 1.0, Color(0xff183132), white),
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return;
      });
}

//////////////  MY TOAST /////////////////
myToast(message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: black,
      textColor: white,
      fontSize: 16.0);
}

class SignUpButton extends StatelessWidget {
  final Function onPress;
  final String name;

  SignUpButton(this.onPress, this.name);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 55,
      child: MyFlatButton(onPress, name, 12.0, white, primary),
    );
  }
}

class MyFlatButton extends StatelessWidget {
  final onPress, name, paddings;
  final textColor, bgColor;
  MyFlatButton(
      this.onPress, this.name, this.paddings, this.textColor, this.bgColor);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: paddings),
        child: Text(
          name,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }
}

//=========================CACHE IMAGE ===================//
class MyCacheImage extends StatelessWidget {
  final String image;
  final double sWidth, sHeight;
  MyCacheImage(this.image, this.sWidth, this.sHeight);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      height: sHeight,
      width: sWidth,
      imageUrl: image,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class WithoutCacheImage extends StatelessWidget {
  final String image;
  WithoutCacheImage(this.image);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: image,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
//======================== QUANTITY BUTTON =================//

class QuantityButton extends StatelessWidget {
  final String child;
  final Function onPress;
  QuantityButton(this.child, this.onPress);
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      constraints: BoxConstraints.tightFor(width: 19, height: 24),
      fillColor: Colors.grey[300],
      child: Text(
        child,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
