import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/models/note.dart';
import 'package:kokoro/screens/drawer.dart';
import 'package:kokoro/widgets/next_meeting_card.dart';
import 'package:kokoro/widgets/next_notes_panel.dart';
import 'package:flutter/services.dart';
import 'package:kokoro/widgets/user_image.dart';
import 'package:provider/provider.dart';
import 'package:kokoro/models/user.dart';
import 'package:kokoro/services/user_services.dart';
import 'package:kokoro/screens/edit_note_screen.dart';

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
                          showDialog(
                            context: context,
                            builder: (context) => EditNoteScreen(
                                note: Note(
                                    content: '',
                                    noteState: NoteState.current,
                                    noteType:
                                        NoteType.values[_tabController.index],
                                  groupId: appUser.currentGroup ?? '',
                                  sentBy: appUser.uid,
                                  createdTime: DateTime.now(),
                                  lastModifiedTime: DateTime.now(),
                                )),
                          );
                        }),
                    backgroundColor: kPrimaryAppColour,
                    drawer: MainDrawer(auth: _auth),
                    body: SafeArea(
                      child: NestedScrollView(
                        physics: ClampingScrollPhysics(),
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: false,
                              snap: true,
                              floating: true,
                              collapsedHeight: 80.0,
                              expandedHeight: 80.0,
                              flexibleSpace: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    'Kokoro',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                    color: kPrimaryTitleColour),
                                  ),
                                  Text(
                                    'Relationship Meetings',
                                    style: TextStyle(fontSize: 14, color: kPrimaryTitleColour),

                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(child: buildUserAvatar(appUser.photoURL), onTap: () {Scaffold.of(context).openDrawer();},),
                                )
                              ],
                              centerTitle: false,
                              backgroundColor: kPrimaryAppColour,
                            ),
                            NextMeetingCard(),
                          ];
                        },
                        body: Column(
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
