import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/screens/drawer.dart';
import 'package:kokoro/widgets/next_meeting_card.dart';
import 'package:kokoro/widgets/next_notes_panel.dart';
import 'package:flutter/services.dart';
import 'package:kokoro/widgets/user_image.dart';
import 'package:provider/provider.dart';
import 'package:kokoro/models/user.dart';
import 'package:kokoro/services/user_services.dart';

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
    // Setup the tab controller
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // Change Android system navigation bar colour to match app
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          kPrimaryBackgroundColour, // navigation bar color
    ));
    // Get firebase user for the uid
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          final user = Provider.of<User>(context);
          return StreamProvider<AppUser>(
            create: (context) => userCollection()
                .doc(user.uid)
                .snapshots()
                .map((snapshot) => documentSnapshotToAppUser(snapshot)),
            initialData: AppUser.initial,
            child: Consumer<AppUser>(
              builder: (context, appUser, _) {
                return Scaffold(
                      floatingActionButton: FloatingActionButton(
                          backgroundColor: kSecondaryAppColour,
                          child: const Icon(Icons.add, size: 40),
                          onPressed: () {
                            // showModalBottomSheet(
                            //   context: context,
                            //   builder: (context) => AddTaskScreen(),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            // );
                          }),
                      backgroundColor: kPrimaryAppColour,
                      drawer: MainDrawer(auth: _auth),
                      body: NestedScrollView(
                        physics: ClampingScrollPhysics(),
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              pinned: false,
                              snap: true,
                              floating: true,
                              expandedHeight: 60.0,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  SizedBox(height: 5),
                                  Text(
                                    'Kokoro',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Relationship Meetings',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: buildUserAvatar(appUser.photoURL),
                                )
                              ],
                              centerTitle: false,
                              backgroundColor: kPrimaryAppColour,
                            ),
                            NextMeetingCard(),
                          ];
                        },
                        body: SafeArea(
                          child: Column(
                            children: [
                              NextNotesTabBar(tabController: _tabController),
                              NextNotesTabs(tabController: _tabController),
                            ],
                          ),
                        ),
                      ));
              },
            ),
          );
        },
      ),
    );
  }
}
