
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:meta/meta.dart';

import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database{

  Stream<UserDetails> readUser(String employeeID);
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

}