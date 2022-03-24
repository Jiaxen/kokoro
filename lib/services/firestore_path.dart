class FirestorePath {
  static String room(String roomId) => 'rooms/$roomId';
  static String rooms() => 'rooms';
  static String user(String uid) => 'users/$uid';
  static String meeting(String roomId, String meetingId) =>
      'rooms/$roomId/meetings/$meetingId';
  static String meetings(String roomId) =>
      'rooms/$roomId/meetings';
  static String notes(String roomId) => 'rooms/$roomId/notes';
  static String note(String roomId, String noteId) => 'rooms/$roomId/notes/$noteId';
}
