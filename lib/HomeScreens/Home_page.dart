import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/AuthenticationScreens/SignUp_Screen.dart';
import 'package:know_it_master/Database_models/PostDetails.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/HomeScreens/Add_Feed.dart';
import 'package:know_it_master/HomeScreens/Profile_Screen.dart';
import 'package:know_it_master/HomeScreens/contact/entry.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_variables/app_functions.dart';
import 'package:know_it_master/common_widgets/button_widget/to_do_button.dart';
import 'package:know_it_master/common_widgets/list_item_builder/list_items_builder.dart';
import 'package:know_it_master/common_widgets/loading_page.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/firebase/database.dart';
import 'package:link/link.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:platform_action_sheet/platform_action_sheet.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'Add_Link.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_HomePage(),
    );
  }
}

class F_HomePage extends StatefulWidget {
  @override
  _F_HomePageState createState() => _F_HomePageState();
}

class _F_HomePageState extends State<F_HomePage> {

  StreamSubscription _intentDataStreamSubscription;
  String _sharedText;
  List<SharedMediaFile> _sharedFiles;


  var database;


  @override
  void initState() {
    super.initState();

    database = Provider.of<Database>( context, listen: false );


    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
          setState(() {
            print("Shared:" + (_sharedFiles?.map((f)=> f.path)?.join(",") ?? ""));
            _sharedFiles = value;
          });
        }, onError: (err) {
          print("getIntentDataStream error: $err");
        });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          setState(() {
            _sharedText = value;
          });
        }, onError: (err) {
          print("getLinkStream error: $err");
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _sharedText = value;
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget( context );
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB( 0, 0, 0, 0 ),
        child: Scaffold(
          body: _buildContent( context ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {

    return StreamBuilder<UserDetails>(
        stream: database.readUser(USER_ID),
        builder: (context, snapshot) {
          final user = snapshot.data;
          PopupMenu.context = context;
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight( 100 ),
              child: Container(
                color: Color( 0xFF222222 ),
                height: MediaQuery
                    .of( context )
                    .size
                    .height / 5,
                width: MediaQuery
                    .of( context )
                    .size
                    .width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all( 10.0 ),
                          child: Column( children: <Widget>[
                            Text(
                              "Know It..!",
                              style: topNavigationBarTitleStyle,
                            ),
                          ] ),
                        ),
                      ],
                    ),
//
//                    GestureDetector(
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.end,
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Padding(
//                              padding:
//                              const EdgeInsets.only( bottom: 15, ),
//                              child: CircleAvatar(
//                                child: Text(
//                                  "Lin",
//                                  style: subTitleStyleLight,
//                                ),
//                                radius: 20.0,
//                                backgroundColor:
//                                subBackgroundColor.withOpacity( .3 ),
//                              ),
//                            )
//                          ],
//                        ),
//                        onTap: () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => AddLink(database: database,),
//                            ),
//                          );
//                        } ),
                    GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only( bottom: 15, right: 10 ),
                              child: CircleAvatar(
                                child: Text(
                                  user != null ? user.username[0] : '...',
                                  style: subTitleStyleLight,
                                ),
                                radius: 20.0,
                                backgroundColor:
                                subBackgroundColor.withOpacity( .3 ),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage( database: database ),
                            ),
                          );
                        } )
                  ],
                ),
              ),
            ),
            body: showFeed( database ),
            floatingActionButton: FloatingActionButton(
              elevation: 90,
              backgroundColor: backgroundColor,
              autofocus: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddFeed(
                          database: database,
                          phoneNumber: user.phoneNumber,
                          totalMediaCount: user.totalMedia,
                        ),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: subBackgroundColor,
              ),
              tooltip: 'Add Company',
            ),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
          );
        } );
  }


  showFeed(Database database) {
    return StreamBuilder<List<PostDetails>>(
      stream: database.readPosts( 'empty', null, 'empty', null, false ),
      builder: (context, postSnapshot) {
        return ListItemsBuilder<PostDetails>(
          snapshot: postSnapshot,
          itemBuilder: (context, postData) =>
              StreamBuilder<UserDetails>(
                stream: database.readUser( postData.postAddedByUid ),
                builder: (context, snapshot) {
                  final postUserData = snapshot.data;

                  return Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all( 10.0 ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  FeedCard( postData, postUserData, context,
                                      database ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
        );
      },
    );
  }

  Widget FeedCard(PostDetails postData, UserDetails postUserData,
      BuildContext context, Database database) {
    return Card(
      elevation: 10,
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all( 10.0 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                child: Text(
                                  postUserData != null ? postUserData
                                      .username[0] : '...',
                                  style: subTitleStyleLight,
                                ),
                                radius: 25.0,
                                backgroundColor: backgroundColor.withOpacity(
                                    .9 ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                postUserData != null
                                    ? postUserData.username
                                    : '...',
                                style: subTitleStyle,
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      InkWell(
                          child: Icon(
                            Icons.more_horiz,
                            color: backgroundColor,
                            size: 30,
                          ),
                          onTap: () {
                            PlatformActionSheet( ).displaySheet(
                                context: context,
                                title: (postData.postAddedByUid != USER_ID) ?
                                Text(
                                  'Once the post is reported it cant be reverted.',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                  ),
                                )
                                    :
                                Text(
                                  'Once the post is deleted it cant be retrived.',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                  ),
                                ),
                                actions: [
                                  if (postData.postAddedByUid !=
                                      USER_ID) ActionSheetAction(
                                    text: "Report",
                                    onPressed: () {
                                      final reported = postData != null
                                          ? postData.reported
                                          : [];
                                      reported.add( USER_ID );
                                      final postEntry = PostDetails(
                                          reported: reported );
                                      database.updatePostEntry( postEntry,
                                          postData != null
                                              ? postData.postID
                                              : 'fetching...' );

                                      Navigator.pop( context );
                                    },
                                    hasArrow: true,
                                  ),
                                  if (postData.postAddedByUid ==
                                      USER_ID) ActionSheetAction(
                                    text: "Delete",
                                    onPressed: () {
                                      final postEntry = PostDetails(
                                          postIsDeleted: true );
                                      database.updatePostEntry( postEntry,
                                          postData != null
                                              ? postData.postID
                                              : 'fetching...' );

                                      Navigator.pop( context );
                                    },
                                  ),
                                  ActionSheetAction(
                                    text: "Cancel",
                                    onPressed: () => Navigator.pop( context ),
                                    isCancel: true,
                                    defaultAction: true,
                                  )
                                ] );
                          } ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 10.0 ),
              child: postData.postType == 0 ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular( 10.0 ),
                      image: DecorationImage(
                          image: NetworkImage( postData.postImagePath ),
                          fit: BoxFit.fill ) ) ) : Padding(
                padding: const EdgeInsets.all( 10.0 ),
                child: Link(
                  child: Text( postData.postUrl, style: urlTextStyle, ),
                  url: postData.postUrl,
                  onError: _showErrorSnackBar,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 10.0 ),
              child: Text(
                postData != null ? postData.postTitle == 'not updated'
                    ? ''
                    : postData.postTitle : 'fetching...',
                style: subTitleStyle,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 10.0 ),
              child: Text(
                postData != null ? postData.postDescription == 'not updated'
                    ? ''
                    : postData.postDescription : 'fetching...',
                style: descriptionStyleDarkBlur,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 10.0 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Correct",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0 ),
                            ),
                          ],
                        ),
                        Text(
                          postData != null ? postData.reactedCorrect.length
                              .toString( ) : '--',
                          style: TextStyle(
                              color: postData.reactedCorrect.contains( USER_ID )
                                  ? Colors.green
                                  : Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0 ),
                        ),
                      ],
                    ),
                    onTap: () {
                      final reactedCorrect = postData != null ? postData
                          .reactedCorrect : [];
                      final reactedWrong = postData != null ? postData
                          .reactedWrong : [];
                      final reactedUIDs = postData != null
                          ? postData.reactedIDs
                          : [];

                      if (postData.reactedIDs.contains( USER_ID )) {
                        if (postData.reactedCorrect.contains( USER_ID )) {
                          reactedCorrect.remove( USER_ID );
                          reactedUIDs.remove( USER_ID );

                          final postEntry = PostDetails(
                              reactedCorrect: reactedCorrect,
                              reactedIDs: reactedUIDs );

                          database.updatePostEntry( postEntry, postData != null
                              ? postData.postID
                              : 'fetching...' );

                          final _userDetails = UserDetails(
                              totalReactions: postUserData.totalReactions - 1 );
                          database.updateUserDetails( _userDetails, USER_ID);
                        } else if (postData.reactedWrong.contains( USER_ID )) {
                          reactedCorrect.add( USER_ID );
                          reactedWrong.remove( USER_ID );

                          final postEntry = PostDetails(
                              reactedCorrect: reactedCorrect,
                              reactedIDs: reactedUIDs,
                              reactedWrong: reactedWrong );

                          database.updatePostEntry( postEntry, postData != null
                              ? postData.postID
                              : 'fetching...' );
                        }
                      } else {
                        reactedCorrect.add( USER_ID );
                        reactedUIDs.add( USER_ID );

                        final postEntry = PostDetails(
                            reactedCorrect: reactedCorrect,
                            reactedIDs: reactedUIDs );
                        database.updatePostEntry( postEntry, postData != null
                            ? postData.postID
                            : 'fetching...' );


                        final _userDetails = UserDetails(
                            totalReactions: postUserData.totalReactions + 1 );
                        database.updateUserDetails(
                            _userDetails, USER_ID);
                      }
                    },
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.close,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Wrong",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0 ),
                              ),
                            ],
                          ),
                          Text(
                            postData != null ? postData.reactedWrong.length
                                .toString( ) : '0',
                            style: TextStyle(
                                color: postData.reactedWrong.contains( USER_ID )
                                    ? Colors.red
                                    : Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0 ),
                          ),
                        ],
                      ),
                      onTap: () {
                        final reactedCorrect = postData != null ? postData
                            .reactedCorrect : [];
                        final reactedWrong = postData != null ? postData
                            .reactedWrong : [];
                        final reactedUIDs = postData != null ? postData
                            .reactedIDs : [];


                        if (postData.reactedIDs.contains( USER_ID )) {
                          if (postData.reactedCorrect.contains( USER_ID )) {
                            reactedCorrect.remove( USER_ID );
                            reactedWrong.add( USER_ID );

                            final postEntry = PostDetails(
                                reactedCorrect: reactedCorrect,
                                reactedIDs: reactedUIDs,
                                reactedWrong: reactedWrong );

                            database.updatePostEntry( postEntry, postData !=
                                null ? postData.postID : 'fetching...' );
                          } else
                          if (postData.reactedWrong.contains( USER_ID )) {
                            reactedWrong.remove( USER_ID );
                            reactedUIDs.remove( USER_ID );

                            final postEntry = PostDetails(
                                reactedIDs: reactedUIDs,
                                reactedWrong: reactedWrong );

                            database.updatePostEntry( postEntry, postData !=
                                null ? postData.postID : 'fetching...' );

                            final _userDetails = UserDetails(
                                totalReactions: postUserData.totalReactions -
                                    1 );
                            database.updateUserDetails( _userDetails, USER_ID);
                          }
                        } else {
                          reactedWrong.add( USER_ID );
                          reactedUIDs.add( USER_ID );

                          final postEntry = PostDetails(
                              reactedWrong: reactedWrong,
                              reactedIDs: reactedUIDs );

                          database.updatePostEntry( postEntry, postData != null
                              ? postData.postID
                              : 'fetching...' );

                          final _userDetails = UserDetails(
                              totalReactions: postUserData.totalReactions + 1 );
                          database.updateUserDetails(
                              _userDetails,USER_ID);
                        }
                      } ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 10.0 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        getDateTime( postData != null
                            ? postData.postAddedDate.seconds
                            : 0 ),
                        style: descriptionStyleDarkBlur,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }

  void _showErrorSnackBar() {
    Scaffold.of( context ).showSnackBar(
      SnackBar(
        content: Text( 'Oops... the URL couldn\'t be opened!' ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text( 'horse' ),
      onPressed: () {
        print( 'horse' );
        Navigator.of( context ).pop( );
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: const Text( 'cow' ),
      onPressed: () {
        print( 'cow' );
        Navigator.of( context ).pop( );
      },
    );
    Widget optionThree = SimpleDialogOption(
      child: const Text( 'camel' ),
      onPressed: () {
        print( 'camel' );
        Navigator.of( context ).pop( );
      },
    );
    Widget optionFour = SimpleDialogOption(
      child: const Text( 'sheep' ),
      onPressed: () {
        print( 'sheep' );
        Navigator.of( context ).pop( );
      },
    );
    Widget optionFive = SimpleDialogOption(
      child: const Text( 'goat' ),
      onPressed: () {
        print( 'goat' );
        Navigator.of( context ).pop( );
      },
    );

    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text( 'Choose an animal' ),
      children: <Widget>[
        optionOne,
        optionTwo,
        optionThree,
        optionFour,
        optionFive,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

}
