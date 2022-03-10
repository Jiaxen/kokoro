class FirestorePath {
  static String group(String groupId) => 'group/$groupId';
  static String users(String uid) => 'users/$uid';
  static String meeting(String groupId, String meetingId) =>
      'group/$groupId/meetings/$meetingId';
  static String notes(String groupId, String uid) => 'users/$groupId/notes';
}
