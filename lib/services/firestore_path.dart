class FirestorePath {
  static String group(String groupId) => 'group/$groupId';
  static String groups() => 'group';
  static String user(String uid) => 'users/$uid';
  static String meeting(String groupId, String meetingId) =>
      'group/$groupId/meetings/$meetingId';
  static String meetings(String groupId) =>
      'group/$groupId/meetings';
  static String notes(String groupId) => 'group/$groupId/notes';
  static String note(String groupId, String noteId) => 'group/$groupId/notes/$noteId';
}
