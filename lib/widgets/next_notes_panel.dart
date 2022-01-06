import 'package:flutter/material.dart';


class NextNotesTabs extends StatelessWidget {
  const NextNotesTabs({
    Key? key,
    required TabController tabController,
  }) : _tabController = tabController, super(key: key);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        NotesPanel(),
        NotesPanel(),
        NotesPanel(),
        NotesPanel(),
      ],
    );
  }
}

class NotesPanel extends StatelessWidget {
  const NotesPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30))),
      child: Center(
        child: Text("It's sunny here"),
      ),
    );
  }
}