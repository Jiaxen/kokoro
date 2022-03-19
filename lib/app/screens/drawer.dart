import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kokoro/constants.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';


class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
    required FirebaseAuth auth,
  })  : _auth = auth,
        super(key: key);

  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kSecondaryAppColour,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryAppColour,
            ),
            child: Text('Kokoro Relationship Meetings',
                style: TextStyle(color: kPrimaryTitleColour)),
          ),
          ListTile(
            title:
            Text('Settings', style: TextStyle(color: kPrimaryTitleColour)),
            onTap: () {
              // Settings screen to be built.
            },
          ),
          ListTile(
            title:
            Text('Sign Out', style: TextStyle(color: kPrimaryTitleColour)),
            onTap: () {
              final progress = ProgressHUD.of(context);
              progress?.show();
              _auth.signOut();
              progress?.dismiss();
            },
          ),
        ],
      ),
    );
  }
}
