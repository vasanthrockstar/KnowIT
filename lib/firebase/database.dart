
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:know_it_master/Database_models/PostDetails.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:meta/meta.dart';

import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database{

  Stream<UserDetails> readUser(String employeeID);
  Future<void> setPostEntry(PostDetails postEntry, String postID);
  Stream<List<PostDetails>> readPosts(String queryKey1, queryValue1, String queryKey2, queryValue2, bool isQuerying);

}

class FirestoreDatabase implements Database {

  FirestoreDatabase({@required this.uid}) : assert (uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Stream<UserDetails> readUser(String employeeID) => _service.documentStream(
    path: APIPath.userDetails(employeeID),
    builder: (data, documentId) => UserDetails.fromMap(data, documentId),
  );

  @override
  Future<void> setPostEntry(PostDetails postEntry, String postID) async => await _service.setData(
    path: APIPath.postDetails(postID),
    data: postEntry.toMap(),
  );

  @override
  Stream<List<PostDetails>> readPosts(String queryKey1, queryValue1, String queryKey2, queryValue2, bool isQuerying) => _service.collectionStream(
    path: APIPath.readPosts(),
    builder: (data, documentId) => PostDetails.fromMap(data, documentId),
    queryBuilder: (query) => !isQuerying ? query.where(queryKey1, isEqualTo: queryValue1) : query.where(queryKey1, isEqualTo: queryValue1).where(queryKey2, isEqualTo: queryValue2),

  );
}