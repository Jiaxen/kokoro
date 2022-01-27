import 'package:flutter/material.dart';
import 'package:kokoro/models/note.dart';
import 'package:kokoro/screens/edit_note_screen.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:kokoro/models/user.dart';
import 'package:kokoro/services/note_services.dart';

class NextNotesTabBar extends StatelessWidget {
  const NextNotesTabBar({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kSecondaryAppColour),
      labelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      isScrollable: true,
      controller: _tabController,
      tabs: noteTypes.map((e) => Tab(text: e)).toList(),
    );
  }
}

class NextNotesTabs extends StatelessWidget {
  const NextNotesTabs({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    if (user.currentGroup == null) {
      return Expanded(
        child: Container(
          color:  kPrimaryAppColour,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    } else {
      return StreamProvider<List<Note>>(
        create: (context) => notesCollection(user.currentGroup!)
            .where('sentBy', isEqualTo: user.uid)
            .where('noteState', isEqualTo: 'current')
            .snapshots()
            .map((snapshot) => fromQueryToNotes(snapshot)),
        initialData: [],
        child: Consumer<List<Note>>(
          builder: (context, notes, _) {
            return Expanded(child:Container(
              color: kPrimaryAppColour,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  NextNotesTab(
                      notes: notes
                          .where((e) => e.noteType == NoteType.appreciation)
                          .toList()),
                  NextNotesTab(
                      notes: notes
                          .where((e) => e.noteType == NoteType.chores)
                          .toList()),
                  NextNotesTab(
                      notes: notes
                          .where((e) => e.noteType == NoteType.plans)
                          .toList()),
                  NextNotesTab(
                      notes: notes
                          .where((e) => e.noteType == NoteType.challenges)
                          .toList()),
                ],
              ),
            ));
          },
        ),
      );
    }
  }
}

class NextNotesTab extends StatelessWidget {
  final List<Note> notes;

  const NextNotesTab({
    Key? key,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kPrimaryBackgroundColour,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25))),
      child: Builder(builder: (BuildContext context) {
        return
          ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(height:10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: kTextBackgroundColour,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditNoteScreen(
                                  note: notes[index]),
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.favorite),
                            title: Text('${notes[index].content}'),
                            subtitle: Text('${notes[index].lastModifiedTime}'),
                          ),
                    ),),
                    SizedBox(height:10),
                  ],
                );
              }
          );
      }),
    );
  }
}

