import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kokoro/screens/login_screen.dart';
import 'package:kokoro/screens/notes_screen.dart';
import 'firebase_options.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        NotesScreen.id: (context) => const NotesScreen(),
      },
    );
  }
}
