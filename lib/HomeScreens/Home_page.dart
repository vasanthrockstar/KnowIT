import'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/AuthenticationScreens/SignUp_Screen.dart';
import 'package:know_it_master/Database_models/PostDetails.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/HomeScreens/Add_Feed.dart';
import 'package:know_it_master/HomeScreens/Profile_Screen.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_variables/app_functions.dart';
import 'package:know_it_master/common_widgets/button_widget/to_do_button.dart';
import 'package:know_it_master/common_widgets/list_item_builder/list_items_builder.dart';
import 'package:know_it_master/common_widgets/loading_page.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/firebase/database.dart';
import 'package:provider/provider.dart';


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
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<UserDetails>(
        stream: database.readUser(USER_ID),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: Container(
                color: Color(0xFF222222),
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: <Widget>[
                            Text(
                              "Know It..!",
                              style: topNavigationBarTitleStyle,
                            ),
                          ]),
                        ),
                      ],
                    ),
                    GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 20, right: 10),
                              child: CircleAvatar(
                                child: Text(
                                  user != null ? user.username[0] : '',
                                  style: subTitleStyleLight,
                                ),
                                radius: 25.0,
                                backgroundColor:
                                subBackgroundColor.withOpacity(.3),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(database: database),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
            body: showFeed(database),
            floatingActionButton: FloatingActionButton(
              elevation: 90,
              backgroundColor: backgroundColor,
              autofocus: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFeed(
                      database: database,
                      phoneNumber: user.phoneNumber,
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
        });
  }
}

showFeed(Database database) {
  return StreamBuilder<List<PostDetails>>(
    stream: database.readPosts('empty',null, 'empty', null,false),
    builder: (context, postSnapshot) {
      return ListItemsBuilder<PostDetails>(
        snapshot: postSnapshot,
        itemBuilder: (context, postData) => StreamBuilder<UserDetails>(
          stream: database.readUser(postData.postAddedByUid),
          builder: (context, snapshot) {
            final postUserData = snapshot.data;

            return Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FeedCard(
                                postUserData != null ? postUserData.username[0] : '.',
                                postUserData != null ? postUserData.username : 'fetching...',
                                postData.postUrl,
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
    String weblink,
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
          postType == 0 ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: subTitleStyle,
              textAlign: TextAlign.start,
            ),
          ) : Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
                child: Text(
                  weblink,
                  style: descriptionStyleDarkBlur,
                ),
                onTap: () {}),
          ),

          postType == 0 ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              description,
              style: descriptionStyleDarkBlur,
              textAlign: TextAlign.start,
            ),
          ) : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: subTitleStyle,
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
