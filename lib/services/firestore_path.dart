class FirestorePath {
  static String room(String roomId) => 'room/$roomId';
  static String rooms() => 'room';
  static String user(String uid) => 'users/$uid';
  static String meeting(String roomId, String meetingId) =>
      'room/$roomId/meetings/$meetingId';
  static String meetings(String roomId) =>
      'room/$roomId/meetings';
  static String notes(String roomId) => 'room/$roomId/notes';
  static String note(String roomId, String noteId) => 'room/$roomId/notes/$noteId';
}
