import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_contact/contacts.dart';
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/firebase/database.dart';
import 'package:platform_action_sheet/platform_action_sheet.dart';

class AddFeed extends StatelessWidget {
  AddFeed({@required this.database, @required this.phoneNumber, @required this.totalMediaCount});
  Database database;
  String phoneNumber;
  int totalMediaCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddFeed(database: database, phoneNumber:phoneNumber, totalMediaCount: totalMediaCount,),
    );
  }
}

class F_AddFeed extends StatefulWidget {
  F_AddFeed({@required this.database, @required this.phoneNumber, @required this.totalMediaCount});
  Database database;
  String phoneNumber;
  int totalMediaCount;

  @override
  _F_AddFeedState createState() => _F_AddFeedState();
}

class _F_AddFeedState extends State<F_AddFeed> {

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


  List<String> CountryCode = new List();
  List<String> ContactNumber = new List();
  List<String> Name = new List();

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
    print(getAllContacts());
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
          postTitle: _postTitle == null ? 'not updated' : _postTitle,
          postDescription: _postDescription == null ? 'not updated' : _postDescription,
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
    return Scaffold(
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
      GestureDetector(
        child: _postPic == null ? Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
              width: 0.5, //
            ),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(10.0),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Add Image",style: subTitleStyle,),
              Icon(Icons.add_photo_alternate,size: 40,)
            ],
          ),
        ) : Container(
          height: 150,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(
                image: FileImage(_postPic),  // here add your image file path
                fit: BoxFit.fill,
              )),
        ),
        onTap: (){

          PlatformActionSheet().displaySheet(
              context: context,
              title:
              Text('Please select the media source.',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                ),
              ),
              actions: [
              ActionSheetAction(
                  text: "Camera",
                  onPressed: () {
                    _captureImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  hasArrow: true,
                ),
                ActionSheetAction(
                  text: "Gallery",
                  onPressed: () {
                    _captureImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ActionSheetAction(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context),
                  isCancel: true,
                  defaultAction: true,
                )
              ]);
        },
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

  Future<void> _captureImage(ImageSource imageSource) async {
    File profileImage = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _postPic = profileImage;
      print(_postPic);
    });
  }
}