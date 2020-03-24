class APIPath {
  static String userDetails(String uid) => 'users/$uid';
  static String usersList() => 'users';

  static String postDetails(String postID) => 'posts/$postID';
  static String readPosts() => 'posts/';
}