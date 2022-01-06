import 'package:flutter/material.dart';

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