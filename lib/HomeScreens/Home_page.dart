import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/AuthenticationScreens/SignUp_Screen.dart';
import 'package:know_it_master/Database_models/PostDetails.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/HomeScreens/Add_Feed.dart';
import 'package:know_it_master/HomeScreens/Add_Link.dart';
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
import 'package:popup_menu/popup_menu.dart';
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
          PopupMenu.context = context;
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
                                   'Lin',
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
                              builder: (context) => AddLink(),
                            ),
                          );
                        }),
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
                                  "Con",
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
                              builder: (context) => MyStatefulWidget(),
                            ),
                          );
                        }),
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
        });
  }
}

showFeed(Database database) {
  return StreamBuilder<List<PostDetails>>(
    stream: database.readPosts('empty', null, 'empty', null, false),
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
                            FeedCard(postData, postUserData, context, database),
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
                                postUserData.username[0],
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
                              postUserData.username,
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
                          showAlertDialog(context);
                        }),
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
                        image: NetworkImage(postData.postImagePath),
                        fit: BoxFit.fill))),
          ),
          postData.postType == 0
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    postData.postTitle,
                    style: subTitleStyle,
                    textAlign: TextAlign.start,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                      child: Text(
                        postData.postUrl,
                        style: descriptionStyleDarkBlur,
                      ),
                      onTap: () {}),
                ),
          postData.postType == 0
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    postData.postDescription,
                    style: descriptionStyleDarkBlur,
                    textAlign: TextAlign.start,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    postData.postTitle,
                    style: subTitleStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
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
                          SizedBox(
                            width: 5,
                          ),
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
                            color: Colors.green,
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

                        database.updatePostEntry(postEntry, postData.postID);

                        final _userDetails = UserDetails(
                            totalReactions: postUserData.totalReactions - 1);
                        database.updateUserDetails(_userDetails, DateTime.now().toString());
                      }else if(postData.reactedWrong.contains(USER_ID)){

                        reactedCorrect.add(USER_ID);
                        reactedWrong.remove(USER_ID);

                        final postEntry = PostDetails(
                            reactedCorrect: reactedCorrect,
                            reactedIDs: reactedUIDs,
                            reactedWrong: reactedWrong);

                        database.updatePostEntry(postEntry, postData.postID);

                      }
                    }else{
                      reactedCorrect.add(USER_ID);
                      reactedUIDs.add(USER_ID);

                      final postEntry = PostDetails(
                          reactedCorrect: reactedCorrect,
                          reactedIDs: reactedUIDs);
                      database.updatePostEntry(postEntry, postData.postID);


                      final _userDetails = UserDetails(
                          totalReactions: postUserData.totalReactions + 1);
                      database.updateUserDetails(_userDetails, DateTime.now().toString());
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
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                        Text(
                          postData.reactedWrong.length.toString(),
                          style: TextStyle(
                              color: Colors.redAccent,
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

                          database.updatePostEntry(postEntry, postData.postID);
                        }else if(postData.reactedWrong.contains(USER_ID)){

                          reactedWrong.remove(USER_ID);
                          reactedUIDs.remove(USER_ID);

                          final postEntry = PostDetails(
                              reactedIDs: reactedUIDs,
                              reactedWrong: reactedWrong);

                          database.updatePostEntry(postEntry, postData.postID);

                          final _userDetails = UserDetails(
                              totalReactions: postUserData.totalReactions - 1);
                          database.updateUserDetails(_userDetails, DateTime.now().toString());

                        }
                      }else{
                        reactedWrong.add(USER_ID);
                        reactedUIDs.add(USER_ID);

                        final postEntry = PostDetails(
                            reactedWrong: reactedWrong,
                            reactedIDs: reactedUIDs);

                        database.updatePostEntry(postEntry, postData.postID);

                        final _userDetails = UserDetails(
                            totalReactions: postUserData.totalReactions + 1);
                        database.updateUserDetails(_userDetails, DateTime.now().toString());

                      }
                    }),
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

showAlertDialog(BuildContext context) {
  // set up the list options
  Widget optionOne = SimpleDialogOption(
    child: const Text('horse'),
    onPressed: () {
      print('horse');
      Navigator.of(context).pop();
    },
  );
  Widget optionTwo = SimpleDialogOption(
    child: const Text('cow'),
    onPressed: () {
      print('cow');
      Navigator.of(context).pop();
    },
  );
  Widget optionThree = SimpleDialogOption(
    child: const Text('camel'),
    onPressed: () {
      print('camel');
      Navigator.of(context).pop();
    },
  );
  Widget optionFour = SimpleDialogOption(
    child: const Text('sheep'),
    onPressed: () {
      print('sheep');
      Navigator.of(context).pop();
    },
  );
  Widget optionFive = SimpleDialogOption(
    child: const Text('goat'),
    onPressed: () {
      print('goat');
      Navigator.of(context).pop();
    },
  );

  // set up the SimpleDialog
  SimpleDialog dialog = SimpleDialog(
    title: const Text('Choose an animal'),
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
