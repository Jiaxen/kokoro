import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kokoro/app/models/note.dart';
import 'package:kokoro/app/screens/edit_note_screen.dart';
import 'package:kokoro/app/screens/find_partner_screen.dart';
import 'package:kokoro/app/screens/notes_screen.dart';

class AppRoutes {
  static const notesScreen = '/notes-screen';
  static const editNoteScreen = '/edit-note-screen';
  static const findPartnerScreen = '/find-partner-screen';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.editNoteScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditNoteScreen(note: args as Note),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.notesScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => NotesScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.findPartnerScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => FindPartnerScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
