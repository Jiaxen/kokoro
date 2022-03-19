import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/note.dart';
import 'package:kokoro/app/screens/edit_note_screen.dart';
import 'package:kokoro/app/top_level_providers.dart';
import '../constants.dart';
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

final notesStreamProvider =
StreamProvider.autoDispose.family<List<Note>, String>((ref, groupId) {
  final database = ref.watch(databaseProvider)!;
  return database.notesStream(groupId: groupId);
});


class NextNotesTabs extends ConsumerWidget {
  const NextNotesTabs({
    Key? key,
    required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value!;
    if (user.currentGroup == null) {
      return LoadingNotes();
    } else {
    final notes = ref.watch(notesStreamProvider(user.currentGroup!));
    return notes.when(
    data: (notes) => ShowNotes(tabController: _tabController, notes: notes),
    loading: () => LoadingNotes(),
    error: (_, __) => LoadingNotes(),
    );
    }
  }
}

class ShowNotes extends StatelessWidget {
  final tabController;
  final notes;
  const ShowNotes({Key? key, this.tabController, this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child:Container(
      color: kPrimaryAppColour,
      child: TabBarView(
        physics: CustomTabBarViewScrollPhysics(),
        controller: tabController,
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
    ));;
  }
}


class LoadingNotes extends StatelessWidget {
  const LoadingNotes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class CustomTabBarViewScrollPhysics extends ScrollPhysics {
  const CustomTabBarViewScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomTabBarViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomTabBarViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 200,
    stiffness: 100,
    damping: 1,
  );
}