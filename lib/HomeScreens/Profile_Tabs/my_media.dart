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
import 'package:provider/provider.dart';

class MyMediaPage extends StatelessWidget {
  const MyMediaPage(
      {Key key,
        this.choice,@required this.database}): super(key: key);
  final Category choice;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_MyMediaPage(database: database,),
    );
  }
}

class F_MyMediaPage extends StatefulWidget {
  F_MyMediaPage({@required this.database});

  final Database database;

  @override
  _F_MyMediaPageState createState() => _F_MyMediaPageState();
}

class _F_MyMediaPageState extends State<F_MyMediaPage> {
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
      stream: widget.database.readPosts('post_added_by_uid', USER_ID, 'post_type', 0, true),
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
                              FeedCard(
                                  postUserData != null ? postUserData.username[0] : '.',
                                  postUserData != null ? postUserData.username : 'fetching...',
                                  postData.postTitle,
                                  postData.postDescription,
                                  postData.postRightCount.toString(),
                                  postData.postWrongCount.toString(),
                                  postData.postImagePath,
                                  getDateTime(postUserData != null ? postData.postAddedDate.seconds : 0),
                                  postData.postType),
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

  Widget FeedCard(
      String initial,
      String name,
//      String weblink,
      String title,
      String description,
      String correctCount,
      String wrongCount,
      String imgLink,
      String date,
      int postType
      ) {
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
                                  initial,
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
                                name,
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
                          onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          image: NetworkImage(imgLink), fit: BoxFit.fill))),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: subTitleStyle,
                textAlign: TextAlign.start,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                description,
                style: descriptionStyleDarkBlur,
                textAlign: TextAlign.start,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: Colors.greenAccent,
                                  ),
                                  Text(
                                    "Correct",
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0),
                                  ),
                                ],
                              ),
                              Text(
                                correctCount,
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.close,
                                    color: Colors.redAccent,
                                  ),
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
                                wrongCount,
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        date,
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




}