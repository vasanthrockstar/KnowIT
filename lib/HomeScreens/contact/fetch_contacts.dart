//import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';

class FetchContacts extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_FetchContacts(),
    );
  }
}

class F_FetchContacts extends StatefulWidget {

  @override
  _F_MyLinksPageState createState() => _F_MyLinksPageState();
}

class _F_MyLinksPageState extends State<F_FetchContacts> {

//  final ContactPicker _contactPicker = new ContactPicker();
//  Contact _contact;

  @override
  Widget build(BuildContext context) {
    return null;
  }
//
//  Widget offlineWidget(BuildContext context) {
//    return CustomOfflineWidget(
//      onlineChild: new MaterialApp(
//        home: new Scaffold(
//          appBar: new AppBar(
//            title: new Text('Plugin example app'),
//          ),
//          body: new Center(
//            child: new Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                new MaterialButton(
//                  color: Colors.blue,
//                  child: new Text("CLICK ME"),
//                  onPressed: () async {
//                    Contact contact = await _contactPicker.selectContact();
//                    setState(() {
//                      _contact = contact;
//                    });
//                  },
//                ),
//                new Text(
//                  _contact == null ? 'No contact selected.' : _contact.toString(),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  Widget _buildContent(BuildContext context) {
    return Center(child: Text('ksbfbf'));
  }
}