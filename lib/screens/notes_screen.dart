import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class NotesScreen extends StatefulWidget {
  static const String id = 'notes_screen';

  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: null,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      final progress = ProgressHUD.of(context);
                      progress?.show();
                      _auth.signOut();
                      progress?.dismiss();
                    }),
              ],
              title: Text('Kokoro Relationship Meetings'),
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: Text('Logged in!'),
          );
        }
      ),
    );
  }
}
