import 'package:flutter/material.dart';

Widget buildUserAvatar(url) {
  return CircleAvatar(
    backgroundImage: url != null ? NetworkImage(url) : null,
    child: url == null ? const Icon(Icons.face) : null,
    // radius: isNotAndroid ? 19 : 17,
  );
}