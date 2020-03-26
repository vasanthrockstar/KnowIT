import'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/AuthenticationScreens/SignUp_Screen.dart';
import 'package:know_it_master/Database_models/PostDetails.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/HomeScreens/Profile_Screen.dart';
import 'package:know_it_master/HomeScreens/categories_tab.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_variables/app_functions.dart';
import 'package:know_it_master/common_widgets/button_widget/to_do_button.dart';
import 'package:know_it_master/common_widgets/list_item_builder/list_items_builder.dart';
import 'package:know_it_master/common_widgets/loading_page.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/firebase/database.dart';
import 'package:link/link.dart';
import 'package:platform_action_sheet/platform_action_sheet.dart';
import 'package:provider/provider.dart';

class MyLinksPage extends StatelessWidget {
  const MyLinksPage(
      {Key key,
        this.choice, @required this.database}): super(key: key);
  final Category choice;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_MyLinksPage(database: database),
    );
  }
}

class F_MyLinksPage extends StatefulWidget {
F_MyLinksPage({@required this.database});
  Database database;

  @override
  _F_MyLinksPageState createState() => _F_MyLinksPageState();
}

class _F_MyLinksPageState extends State<F_MyLinksPage> {
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget (BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB( 0, 0, 0, 0 ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return showFeed();
  }


  Widget showFeed() {
    return StreamBuilder<List<PostDetails>>(
      stream: widget.database.readPosts('post_added_by_uid', USER_ID, 'post_type', 1, true),
      builder: (context, postSnapshot) {
        return ListItemsBuilder<PostDetails>(
          snapshot: postSnapshot,
          itemBuilder: (context, postData) => StreamBuilder<UserDetails>(
            stream: widget.database.readUser(postData.postAddedByUid),
            builder: (context, snapshot) {
              final postUserData = snapshot.data;

              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FeedCard(postData, postUserData, context),
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
      BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                                  postUserData != null ? postUserData.username[0] : '.',
                                  style: subTitleStyleLight,
                                ),
                                radius: 25.0,
                                backgroundColor: backgroundColor.withOpacity(.9),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                postUserData != null ? postUserData.username : "fetching...",
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


                            PlatformActionSheet().displaySheet(
                                context: context,
                                title: (postData.postAddedByUid != USER_ID) ?
                                Text('Once the post is reported it cant be reverted.',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                  ),
                                )
                                    :
                                Text('Once the post is deleted it cant be retrived.',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat-Regular',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.0,
                                  ),
                                ),
                                actions: [
                                  if (postData.postAddedByUid != USER_ID) ActionSheetAction(
                                    text: "Report",
                                    onPressed: () {
                                      final reported = postData != null ? postData.reported : [];
                                      reported.add(USER_ID);
                                      final postEntry = PostDetails(
                                          reported: reported);
                                      widget.database.updatePostEntry(postEntry, postData != null ? postData.postID : 'fetching...');

                                      Navigator.pop(context);
                                    },
                                    hasArrow: true,
                                  ),
                                  if (postData.postAddedByUid == USER_ID)  ActionSheetAction(
                                    text: "Delete",
                                    onPressed: () {
                                      final postEntry = PostDetails(
                                          postIsDeleted: true);
                                      widget.database.updatePostEntry(postEntry, postData != null ? postData.postID : 'fetching...');

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

                          }),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Link(
                child: Text(postData.postUrl,style: urlTextStyle,),
                url: postData.postUrl,
                onError: _showErrorSnackBar,
              ),
            ),
            postData != null ? postData.postTitle == 'not updated' ? Container(height: 0, width: 0,) : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                postData != null ? postData.postTitle == 'not updated' ? '' : postData.postTitle : 'fetching...',
                style: subTitleStyle,
                textAlign: TextAlign.start,
              ),
            ) : null,
            postData != null ? postData.postDescription == 'not updated' ? Container(height: 0, width: 0,) : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                postData != null ? postData.postDescription == 'not updated' ? '' : postData.postDescription : 'fetching...',
                style: descriptionStyle,
                textAlign: TextAlign.start,
              ),
            ) : null,
            Padding(
              padding: const EdgeInsets.all(10.0),
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
                            SizedBox(width: 5,),
                            Text(
                              "Correct",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                        Text(
                          postData.reactedCorrect.length.toString(),
                          style: TextStyle(
                              color: postData.reactedCorrect.contains(USER_ID) ? Colors.green : Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                    onTap: () {

                      final reactedCorrect = postData.reactedCorrect;
                      final reactedWrong = postData.reactedWrong;
                      final reactedUIDs = postData.reactedIDs;

                      if(postData.reactedIDs.contains(USER_ID)){

                        if(postData.reactedCorrect.contains(USER_ID)){
                          reactedCorrect.remove(USER_ID);
                          reactedUIDs.remove(USER_ID);

                          final postEntry = PostDetails(
                              reactedCorrect: reactedCorrect,
                              reactedIDs: reactedUIDs);

                          widget.database.updatePostEntry(postEntry, postData.postID);

                          final _userDetails = UserDetails(
                              totalReactions: postUserData.totalReactions - 1);
                          widget.database.updateUserDetails(_userDetails, USER_ID);
                        }else if(postData.reactedWrong.contains(USER_ID)){

                          reactedCorrect.add(USER_ID);
                          reactedWrong.remove(USER_ID);

                          final postEntry = PostDetails(
                              reactedCorrect: reactedCorrect,
                              reactedIDs: reactedUIDs,
                              reactedWrong: reactedWrong);

                          widget.database.updatePostEntry(postEntry, postData.postID);

                        }
                      }else{
                        reactedCorrect.add(USER_ID);
                        reactedUIDs.add(USER_ID);

                        final postEntry = PostDetails(
                            reactedCorrect: reactedCorrect,
                            reactedIDs: reactedUIDs);

                        widget.database.updatePostEntry(postEntry, postData.postID);

                        final _userDetails = UserDetails(
                            totalReactions: postUserData.totalReactions + 1);
                        widget.database.updateUserDetails(_userDetails, USER_ID);
                      }
                    },
                  ),
                  SizedBox(
                    width:45,
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
                            SizedBox(width: 5,),
                            Text(
                              "Wrong",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                        Text(
                          postData.reactedWrong.length.toString(),
                          style: TextStyle(
                              color: postData.reactedWrong.contains(USER_ID) ? Colors.redAccent : Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                      onTap: () {

                        final reactedCorrect = postData.reactedCorrect;
                        final reactedWrong = postData.reactedWrong;
                        final reactedUIDs = postData.reactedIDs;


                        if(postData.reactedIDs.contains(USER_ID)){

                          if(postData.reactedCorrect.contains(USER_ID)){
                            reactedCorrect.remove(USER_ID);
                            reactedWrong.add(USER_ID);

                            final postEntry = PostDetails(
                                reactedCorrect: reactedCorrect,
                                reactedIDs: reactedUIDs,
                                reactedWrong: reactedWrong);

                            widget.database.updatePostEntry(postEntry, postData.postID);
                          }else if(postData.reactedWrong.contains(USER_ID)){

                            reactedWrong.remove(USER_ID);
                            reactedUIDs.remove(USER_ID);

                            final postEntry = PostDetails(
                                reactedIDs: reactedUIDs,
                                reactedWrong: reactedWrong);

                            widget.database.updatePostEntry(postEntry, postData.postID);

                            final _userDetails = UserDetails(
                                totalReactions: postUserData.totalReactions - 1);
                            widget.database.updateUserDetails(_userDetails, USER_ID);

                          }
                        }else{
                          reactedWrong.add(USER_ID);
                          reactedUIDs.add(USER_ID);

                          final postEntry = PostDetails(
                              reactedWrong: reactedWrong,
                              reactedIDs: reactedUIDs);

                          widget.database.updatePostEntry(postEntry, postData.postID);

                          final _userDetails = UserDetails(
                              totalReactions: postUserData.totalReactions + 1);
                          widget.database.updateUserDetails(_userDetails, USER_ID);
                        }
                      }
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        getDateTime(postData.postAddedDate.seconds),
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
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }
}