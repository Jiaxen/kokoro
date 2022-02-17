import 'package:flutter/material.dart';
import 'package:kokoro/models/group.dart';
import 'package:kokoro/models/user.dart';
import 'package:kokoro/services/group_services.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../constants.dart';

class FindPartnerScreen extends StatefulWidget {
  static const String id = 'find_partner_screen';

  const FindPartnerScreen({Key? key}) : super(key: key);

  @override
  _FindPartnerScreenState createState() => _FindPartnerScreenState();
}

class _FindPartnerScreenState extends State<FindPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryAppColour,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: Column(children: [
              addPartnerInterface(),
              partnersDoodle(),
            ]),
          ),
        ),
      ),
    );
  }

  Row partnersDoodle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: kTextBackgroundColour, shape: BoxShape.circle),
                ),
                SizedBox(height: 40)
              ],
            ),
            Image(
                image: AssetImage('images/ReadingSideDoodle.png'), height: 120),
          ],
        ),
        Column(
          children: [
            SizedBox(height: 60),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Transform.rotate(
                  angle: -math.pi / 4,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: kTextBackgroundColour,
                  ),
                ),
                Image(
                    image: AssetImage('images/SitReadingDoodle.png'),
                    height: 120),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column addPartnerInterface() {
    final myController = TextEditingController();
    Group group = Provider.of<Group>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add your partner',
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: kPrimaryTitleColour)),
        SizedBox(height: 20),
        Text('Partner\'s email',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kPrimaryTitleColour)),
        SizedBox(height: 10),
        TextField(
            controller: myController,
            autofocus: true,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kSecondaryAppColour, width: 1.0),
                  gapPadding: 4,
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              filled: true,
              fillColor: kTextBackgroundColour,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              hintText: 'booboo@mail.com',
            ),
            keyboardType: TextInputType.emailAddress,
            minLines: 1,
            maxLines: 1),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.topRight,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
              backgroundColor: MaterialStateProperty.all<Color>(
                  kWarningBackgroundColorLight),
              foregroundColor:
                  MaterialStateProperty.all<Color>(kPrimaryTitleColour),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              )),
            ),
            onPressed: () {
              if (myController.text != "") {
                group.invitedMembers != null
                    ? group.invitedMembers!.add(myController.text.toLowerCase())
                    : group.invitedMembers = [myController.text.toLowerCase()];
                // TODO: Email the user
                saveGroupToFireStore(group);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Text('Add'),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
