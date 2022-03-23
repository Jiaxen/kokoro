import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kokoro/app/models/user.dart';
import 'package:kokoro/app/models/room.dart';
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

final invitedRoomsProvider = StreamProvider<List<Room>>((ref) {
  final database = ref.watch(databaseProvider)!;
  final userAsyncValue = ref.watch(userProvider);
  return userAsyncValue.when(
    data: (user) => database.invitedRoomStream(user),
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
},
);

final roomProvider = StreamProvider<Room>(
  (ref) {
    final database = ref.watch(databaseProvider)!;
    final userAsyncValue = ref.watch(userProvider);
    return userAsyncValue.when(
      data: (user) => user.currentRoom == null
          ? Stream.value(Room.noRoom)
          : database.roomStream(roomId: user.currentRoom!),
      loading: () => Stream.value(Room.initial),
      error: (_, __) => Stream.value(Room.initial),
    );
  },
);

final loggerProvider = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
        methodCount: 1,
        printEmojis: false,
      ),
    ));
