import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kokoro/screens/find_partner_screen.dart';
import 'package:kokoro/screens/login_screen.dart';
import 'package:kokoro/screens/notes_screen.dart';
import 'package:kokoro/services/user_services.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'package:kokoro/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Provider of Firebase user at the top of the app tree
    return MultiProvider(
      providers:[
      StreamProvider<User?>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser),
        StreamProvider<AppUser>(
          create: (context) => userCollection()
              .doc(Provider.of<User?>(context, listen: false)?.uid)
              .snapshots()
              .map((snapshot) => documentSnapshotToAppUser(snapshot)),
          initialData: AppUser.initial)
      ],
          child: Builder(
            builder: (context) {
              final user = Provider.of<User?>(context);
              return MaterialApp(
                builder: (context, child) {
                  return ScrollConfiguration(
                    behavior: NoGlowScrollBehavior(),
                    child: child!,
                  );
                },
                home: (user == null) ? const LoginScreen() : const NotesScreen(),
                routes: {
                  LoginScreen.id: (context) => const LoginScreen(),
                  NotesScreen.id: (context) => const NotesScreen(),
                  FindPartnerScreen.id: (context) => const FindPartnerScreen(),
                },
              );
            }
          )
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}