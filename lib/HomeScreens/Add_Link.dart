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

class AddLink extends StatelessWidget {
  AddLink({@required this.database, @required this.phoneNumber, @required this.totalMediaCount});
  Database database;
  String phoneNumber;
  int totalMediaCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddLink(database: database, phoneNumber:phoneNumber),
    );
  }
}

class F_AddLink extends StatefulWidget {
  F_AddLink({@required this.database, @required this.phoneNumber, @required this.totalMediaCount});
  Database database;
  String phoneNumber;
  int totalMediaCount;

  @override
  _F_AddLinkState createState() => _F_AddLinkState();
}

class _F_AddLinkState extends State<F_AddLink> {

  File _postPic;
  String _postTitle;
  String _postDescription;

  final _formKey = GlobalKey<FormState>();

  final FirebaseStorage _storage =
  FirebaseStorage(storageBucket: FIREBASE_STORAGE_URL);
  StorageUploadTask _uploadTask;
  String _profilePicPathURL;

  bool _loading;
  double _progressValue;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
  }


  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void _imageUpload() async {
    _loading = !_loading;
    if (_postPic != null) {
      String _postPicPath = 'post_images/${DateTime.now()}.png';
      setState(() {
        _uploadTask =
            _storage.ref().child(_postPicPath).putFile(_postPic);
      });
      _profilePicPathURL = await (await _storage
          .ref()
          .child(_postPicPath)
          .putFile(_postPic)
          .onComplete)
          .ref
          .getDownloadURL();

      _submit(_profilePicPathURL);
    }
  }

  Future<void> _submit(String imagePath) async{
    if(_validateAndSaveForm()) {
      try{

        final _postEntry = PostDetails(
          postIsDeleted: false,
          postAddedDate: Timestamp.fromDate(DateTime.now()),
          postAddedByUid: USER_ID,
          postAddedByPhoneNumber: widget.phoneNumber.substring(3),
          postImagePath: imagePath,
          postTitle: _postTitle,
          postDescription: _postDescription,
          postUrl: 'not updated',
          postType: 0, //0 for image type, 1 for link type
          postViewCount: 0,
          postVisitedCount: 0,
          reactedCorrect: [],
          reactedWrong: [],
          reported: [],
          reactedIDs: [],
          empty: null,
        );

        await widget.database.setPostEntry(_postEntry, DateTime.now().toString());

        final _userDetails = UserDetails(
            totalMedia: widget.totalMediaCount + 1);
        await widget.database.updateUserDetails(_userDetails, DateTime.now().toString());

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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: CustomAppBar(
          leftActionBar: Container(
            child: Icon(Icons.arrow_back, size: 40,color: Colors.black38,),
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
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events == null ? null : _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            _progressValue = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LinearProgressIndicator(
                    value: _progressValue,
                  ),
                  Text('${(_progressValue * 100).round()}%'),
                ],
              );
          });
    } else {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ToDoButton(
          assetName: 'images/googl-logo.png',
          text: 'Post',
          textColor: subBackgroundColor,
          backgroundColor: backgroundColor,
          onPressed: _imageUpload,
        ),
      );
//    AnimatedButton(
//        onTap: _imageUpload,
//        animationDuration: const Duration(milliseconds: 1000),
//        initialText: "Post",
//        finalText: "Feed Added",
//        iconData: Icons.check,
//        iconSize: 30.0,
//        buttonStyle: ButtonStyle(
//          primaryColor: backgroundColor,
//          secondaryColor: Colors.white,
//          elevation: 10.0,
//          initialTextStyle: TextStyle(
//            fontSize: 20.0,
//            color: subBackgroundColor,
//          ),
//          finalTextStyle: TextStyle(
//            fontSize: 20.0,
//            color: backgroundColor,
//          ),
//          borderRadius: 10.0,
//        ),
//
//      );
    }
  }


  List<Widget>postContent() {

    return [
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
      Center(
        child: Link(
          child: Text('https://pub.dev/packages/link',style: TextStyle(color: subBackgroundColor,decoration: TextDecoration.underline,),),
          url: 'https://flutter.dev',
          onError: _showErrorSnackBar,
        ),
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

  Future<void> _captureImage() async {
    File profileImage = await ImagePicker.pickImage(source: IMAGE_SOURCE);
    setState(() {
      _postPic = profileImage;
      print(_postPic);
    });
  }
}