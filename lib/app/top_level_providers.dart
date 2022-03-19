import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/app/models/group.dart';
import 'package:kokoro/services/firestore_database.dart';
import 'package:logger/logger.dart';

final firebaseAuthProvider =
Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
        (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final databaseProvider = Provider<FirestoreDatabase?>((ref) {
  final auth = ref.watch(authStateChangesProvider);

  if (auth.asData?.value?.uid != null) {
    return FirestoreDatabase(uid: auth.asData!.value!.uid);
  }
  return null;
});

final userProvider = StreamProvider<AppUser>((ref) {
  final database = ref.watch(databaseProvider)!;
  return database.appUserStream();
});

final groupProvider = StreamProvider<Group>((ref) {
  final database = ref.watch(databaseProvider)!;
  final userAsyncValue = ref.watch(userProvider);
  return userAsyncValue.when(
    data: (user) => database.groupStream(groupId: user.currentGroup!),
    loading: () => Stream.value(Group.initial),
    error: (_,__) => Stream.value(Group.initial),
  );
});

final loggerProvider = Provider<Logger>((ref) =>
    Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
