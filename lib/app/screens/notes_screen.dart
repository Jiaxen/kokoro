import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/room.dart';
import 'package:kokoro/app/top_level_providers.dart';
import 'package:kokoro/constants.dart';
import 'package:kokoro/app/models/note.dart';
import 'package:kokoro/app/screens/drawer.dart';
import 'package:kokoro/app/widgets/room_management_card.dart';
import 'package:kokoro/app/widgets/next_notes_panel.dart';
import 'package:flutter/services.dart';
import 'package:kokoro/app/widgets/user_image.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/app/screens/edit_note_screen.dart';

class NotesScreen extends ConsumerStatefulWidget {
  static const String id = 'notes_screen';

  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen>
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
    AppUser appUser = ref
        .watch(userProvider)
        .value!;
    Room room = ref
        .watch(roomProvider)
        .value!;
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return NotesDisplay(
            tabController: _tabController, auth: _auth, appUser: appUser, room: room);
        },
      ),
    );
  }
}

class NotesDisplay extends StatelessWidget {
  const NotesDisplay({
    Key? key,
    required TabController tabController,
    required FirebaseAuth auth,
    required this.appUser,
    required this.room,
  })
      : _tabController = tabController,
        _auth = auth,
        super(key: key);

  final TabController _tabController;
  final FirebaseAuth _auth;
  final AppUser appUser;
  final Room room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: kSecondaryAppColour,
            child: const Icon(Icons.add, size: 40),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    EditNoteScreen(
                        note: Note(
                          id: null,
                          content: '',
                          noteState: NoteState.current,
                          noteType:
                          NoteType.values[_tabController.index],
                          roomId: appUser.currentRoom ?? '',
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
                  collapsedHeight: 75.0,
                  expandedHeight: 75.0,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'Kokoro Relationship Meetings',
                          style: TextStyle(
                              fontSize: 14, color: kPrimaryTitleColour),
                        ),
                        SizedBox(height: 3),
                        Text(
                          room.roomName ?? 'Kokoro',
                          style: mainTitleStyle(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // SizedBox(height: 5),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20, bottom: 0),
                      child: InkWell(
                        child: buildUserAvatar(appUser.photoURL), onTap: () {
                        Scaffold.of(context).openDrawer();
                      },),
                    )
                  ],
                  centerTitle: false,
                  backgroundColor: kPrimaryAppColour,
                ),
                RoomManagementCard(),
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
  }

}

