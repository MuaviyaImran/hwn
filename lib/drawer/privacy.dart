import 'package:flutter/material.dart';
import 'package:hwn_mart/bars/top.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  var kHtml = """
  <center><h2><b><u> Privacy </b></u></h2></center>
    Welcome to HWN MART official app powered by HWN BROTHER’S (registration no:) .We care about your personal content and your personal information. To learn more, please read this privacy policy.
    This privacy policy explains how we collect, use (under some conditions) and disclose your personal information.  This privacy policy also explains how we secure and protect your personal information. Our whole privacy policy explains your options about using and disclosing your data. By visiting the app or signing up directly or indirectly, you accept the conditions mentioned  below.
    <h3><b><u>What information will we use?</h3></b></u>
    Nowadays everyone’s privacy is an issue and we care about your personal information. Your privacy is important to us.Therefore we only use your name and other information like email address, mobile number and address(if you ask for a home delivery). And we will only collect information when it’s necessary for us to do so and we will only collect information if it is relevant to our dealings with you.We may further use some of your information like email address and your mobile number regarding app updates and other events likely about the offers given by the stores.
    <h3><b><u>How long do we use it?</h3></b></u>
    We only will keep your information as long as we are either required by law or as  it is relevant to our dealings with you. You can visit the app and search without having to provide your personal data. While you are visiting the app you remain anonymous and cannot identify yourself unless you have an account and you login with your username and password.
    <h3><b><u>About delivery charges</h3></b></u>
    We may collect some information if you seek to place an order. We  may collect your title, name, gender, date of birth, email address, delivery address (if that differs from other), mobile and telephone number. We don’t collect any information regarding your online payments or bank account .No third party is involved with us and we will not disclose your data to any other person.The order will be on your doorstep within 2 to 7 working days. Payments will be on delivery. Payment method will be cash. The charges will be 50 rupees per order in the city. If the order you placed is out of the city then tsc company rate will be applied +50 rupees.
    <h3><b><u>How can you advertise with us?</h3></b></u>
    If you are looking to advertise your product on a digital platform. You are on the right spot. We advertise your product under your store name and banner. We would not use our name or any third person name for your product. We will not get any extra charges more than you mentioned. Our rates are so cool.  
    By signing up you agree to give access to your name,email address,mobile number, address.
    I agree to receive updates.

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DrawerTopBar().getAppBar("Privacy Policy", context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: HtmlWidget(
            "$kHtml",
            webView: false,
          ),
        ),
      ),
    );
  }
}
