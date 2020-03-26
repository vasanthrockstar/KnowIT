import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:know_it_master/Database_models/PostDetails.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_variables/app_functions.dart';
import 'package:know_it_master/common_widgets/button_widget/add_to_cart_button.dart';
import 'package:know_it_master/common_widgets/button_widget/to_do_button.dart';
import 'package:know_it_master/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/common_widgets/platform_alert/platform_exception_alert_dialog.dart';
import 'package:link/link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/firebase/database.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class AddLink extends StatelessWidget {
  AddLink({@required this.database, @required this.url, @required this.phoneNumber, @required this.totalLinkCount});
  Database database;
  String url;
  String phoneNumber;
  int totalLinkCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddLink(database: database, url: url,phoneNumber: phoneNumber, totalLinkCount:totalLinkCount),
    );
  }
}

class F_AddLink extends StatefulWidget {
  F_AddLink({@required this.database, @required this.url, @required this.phoneNumber, @required this.totalLinkCount});
  Database database;
  String url;
  String phoneNumber;
  int totalLinkCount;

  @override
  _F_AddLinkState createState() => _F_AddLinkState();
}

class _F_AddLinkState extends State<F_AddLink> {

  String _postTitle;
  String _postDescription;

  final _formKey = GlobalKey<FormState>();


  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async{
    if(_validateAndSaveForm()) {
      var date = Timestamp.fromDate(DateTime.now());
      try{

        final _postEntry = PostDetails(
          postIsDeleted: false,
          postAddedDate: date,
          postAddedByUid: USER_ID,
          postAddedByPhoneNumber: widget.phoneNumber,
          postImagePath: 'not updated',
          postTitle: _postTitle,
          postDescription: _postDescription,
          postUrl: widget.url,
          postType: 0, //0 for image type, 1 for link type
          postViewCount: 0,
          postVisitedCount: 0,
          reactedCorrect: [],
          reactedWrong: [],
          reported: [],
          reactedIDs: [],
          empty: null,
        );

        await widget.database.setPostEntry(_postEntry, date.toString());

        final _userDetails = UserDetails(
            totalMedia: widget.totalLinkCount + 1);
        await widget.database.updateUserDetails(_userDetails, USER_ID);

        Navigator.of(context).pop();
      }on PlatformException catch (e){
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return Center(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: CustomAppBar(
            leftActionBar: Container(
              child: Icon(Icons.arrow_back, size: 40,color: Colors.white70,),
            ),
            leftAction: (){
              Navigator.pop(context,true);
            },
            primaryText: null,
            secondaryText: 'Add Feed',
            tabBarWidget: null,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildContent(),
              Container(
                child: _buildPageContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: postContent(),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ToDoButton(
          assetName: 'images/googl-logo.png',
          text: 'Post',
          textColor: subBackgroundColor,
          backgroundColor: backgroundColor,
          onPressed: _submit,
        ),
      );
  }


  List<Widget>postContent() {

    return [
      Text('Shared URL :'),
      SizedBox(height: 10,),

      Link(
        child: Text(widget.url != null ? widget.url : 'nothing to share',style: TextStyle(color: subBackgroundColor,decoration: TextDecoration.underline,),),
        url: 'https://flutter.dev',
        onError: _showErrorSnackBar,
      ),
      SizedBox(height: 20,),
      new TextField(
        onChanged: (value) => _postTitle = value,
        minLines: 2,
        maxLines: 3,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: 'Add title',
          filled: true,
          fillColor: Colors.black12,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        style: descriptionStyleDark,
        keyboardType: TextInputType.text,
        keyboardAppearance: Brightness.dark,
      ),

      SizedBox(height: 20,),
      TextField(
        onChanged: (value) => _postDescription = value,
        minLines: 2,
        maxLines: 5,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: 'Add description.',
          filled: true,
          fillColor: Colors.black12,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        style: descriptionStyleDark,
        keyboardType: TextInputType.text,
        keyboardAppearance: Brightness.dark,
      ),
    ];
  }
  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }
}