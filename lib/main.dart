import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kokoro/models/group.dart';
import 'package:kokoro/screens/find_partner_screen.dart';
import 'package:kokoro/screens/login_screen.dart';
import 'package:kokoro/screens/notes_screen.dart';
import 'package:kokoro/services/group_services.dart';
import 'package:kokoro/services/shared_preferences_service.dart';
import 'package:kokoro/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kokoro/models/user.dart';
import 'package:kokoro/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    // Provider of Firebase user at the top of the app tree
    return MultiProvider(
        providers: [
          FirebaseUserStream(),
          AppUserStream(),
          GroupStream(),
        ],
        child: Builder(builder: (context) {
          final user = Provider.of<User?>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
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
        }));
  }

  StreamProvider<User?> FirebaseUserStream() {
    return StreamProvider<User?>.value(
            value: FirebaseAuth.instance.authStateChanges(),
            initialData: FirebaseAuth.instance.currentUser);
  }

  StreamProvider<Group> GroupStream() {
    return StreamProvider<Group>(
          create: (context) {
            String? appUserGroup = Provider.of<AppUser>(context, listen: false).currentGroup;
            print(appUserGroup);
            return groupCollection()
              .doc(appUserGroup)
              .snapshots()
              .map((snapshot) => documentSnapshotToGroup(snapshot));
          },
          initialData: Group.initial,
        );
  }

  StreamProvider<AppUser> AppUserStream() {
    return StreamProvider<AppUser>(
            create: (context) => userCollection()
                .doc(Provider.of<User?>(context, listen: false)?.uid)
                .snapshots()
                .map((snapshot) => documentSnapshotToAppUser(snapshot)),
            initialData: AppUser.initial);
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
