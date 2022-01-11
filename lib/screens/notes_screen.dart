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
  final _scrollController = ScrollController();
  bool isTopOfScreen = true;

  @override
  void initState() {
    super.initState();
    // Setup the tab controller
    _tabController = TabController(length: 4, vsync: this);
    // Setup the scroll listener to determine if at top of page
    _scrollController.addListener(
      () {
        setState(
          () {
            if (_scrollController.position.pixels == 0) {
              isTopOfScreen = true;
            } else {
              isTopOfScreen = false;
            }
          },
        );
      },
    );
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
                  backgroundColor: kPrimaryBackgroundColour,
                  drawer: MainDrawer(auth: _auth),
                  appBar: AppBar(
                    actions: [Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildUserAvatar(appUser.photoURL),
                    )],
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kokoro',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Relationship Meetings',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    centerTitle: false,
                    backgroundColor: kPrimaryAppColour,
                    elevation: isTopOfScreen ? 0 : 1,
                  ),
                  body: ListView(
                    controller: _scrollController,
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      NextMeetingCard(),
                      NextMeetingNotes(tabController: _tabController),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NextMeetingNotes extends StatelessWidget {
  const NextMeetingNotes({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: safeHeight - 50,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: kPrimaryAppColour,
          child: NextNotesTabBar(tabController: _tabController),
        ),
        Expanded(
          child: Container(
            color: kPrimaryAppColour,
            child: NextNotesTabs(tabController: _tabController),
          ),
        ),
      ]),
    );
  }
}
