import 'package:flutter/material.dart';
import 'package:kokoro/models/note.dart';
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
    return SliverToBoxAdapter(
      child: Container(
        color: kPrimaryAppColour,
        child: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kSecondaryAppColour),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          isScrollable: true,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Appreciations'),
            Tab(text: 'Chores'),
            Tab(text: 'Plans'),
            Tab(text: 'Challenges'),
          ],
        ),
      ),
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
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return StreamProvider<List<Note>>(
        create: (context) => NotesCollection(user.currentGroup!)
            .where('sentBy', isEqualTo: user.uid)
            .where('noteState', isEqualTo: 'current')
            .snapshots()
            .map((snapshot) => fromQueryToNotes(snapshot)),
        initialData: [],
        child: Consumer<List<Note>>(
          builder: (context, notes, _) {
            return TabBarView(
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
            );
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
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(builder: (BuildContext context) {
        return CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('note: ${notes[index].content}')
                );
              },childCount: notes.length,
            ),
          ),
          // SliverFillRemaining(
          //   child: Container(
          //     color: Colors.blue[100],
          //     child: Icon(
          //       Icons.sentiment_very_satisfied,
          //       size: 75,
          //       color: Colors.blue[900],
          //     ),
          //   ),
          // ),
        ]);
      }),
    );
  }
}
