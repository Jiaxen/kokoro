import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/screens/drawer.dart';

class NotesScreen extends StatefulWidget {
  static const String id = 'notes_screen';

  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: kPrimaryBackgroundColour,
          drawer: MainDrawer(auth: _auth),
          appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Kokoro',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Relationship Meetings',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
              centerTitle: false,
              backgroundColor: kPrimaryAppColour,
              elevation: 0),
          body: ListView(
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                color: kPrimaryAppColour,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: kSecondaryAppColour,
                    child: ListTile(
                      leading:
                          Icon(Icons.event, size: 56, color: Colors.amber[100]),
                      title: Text('Next meeting in 3 days',
                          style: TextStyle(color: kPrimaryTitleColour)),
                      subtitle: Text('Monday 31st Feb @5.30pm',
                          style: TextStyle(color: kPrimaryTitleColour)),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              Container(
                height: safeHeight - 50,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        color: kPrimaryAppColour,
                        child: TabBar(
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kSecondaryAppColour),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                          isScrollable: true,
                          controller: _tabController,
                          tabs: const <Widget>[
                            Tab(text: 'Appreciation'),
                            Tab(text: 'Chores'),
                            Tab(text: 'Plans'),
                            Tab(text: 'Problems'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: kPrimaryAppColour,
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Center(
                                  child: Text("It's sunny here"),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Center(
                                  child: Text("It's cloudy here"),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Center(
                                  child: Text("It's looking good here"),
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                child: Center(
                                  child: Text("It's rainy here"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        );
      }),
    );
  }
}
