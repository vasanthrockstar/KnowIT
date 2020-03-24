
import 'package:cloud_firestore/cloud_firestore.dart';
class PostDetails{
  PostDetails({
    this.postIsDeleted,
    this.postAddedDate,
    this.postAddedByUid,
    this.postAddedByPhoneNumber,
    this.postImagePath,
    this.postLocation,
    this.postTitle,
    this.postUrl,
    this.empty,
    this.postDescription,
    this.postReportedCount,
    this.postType,
    this.postViewCount,
    this.postVisitedCount,
    this.postWrongCount,
    this.postRightCount,
    this.postID,

  });

  final bool postIsDeleted;
  final Timestamp postAddedDate;
  final String postAddedByUid;
  final String postAddedByPhoneNumber;
  final String postImagePath;
  final GeoPoint postLocation;
  final String postTitle;
  final String postDescription;
  final String postUrl;
  final int postReportedCount;
  final int postType;
  final int postViewCount;
  final int postVisitedCount;
  final int postWrongCount;
  final int postRightCount;

  final String postID;
  final Null empty;



  factory PostDetails.fromMap(Map<String, dynamic> data, String documentID){
    if(data == null){
      return null;
    }
    final String postID = documentID;

    final bool postIsDeleted = data['post_is_deleted'];
    final Timestamp postAddedDate = data['post_added_date'];
    final String postAddedByUid = data['post_added_by_uid'];
    final String postAddedByPhoneNumber = data['post_added_by_phone_number'];
    final String postImagePath = data['post_image_path'];
    final GeoPoint postLocation = data['post_location'];
    final String postTitle = data['post_title'];
    final String postDescription = data['post_description'];
    final String postUrl = data['post_url'];
    final int postReportedCount = data['post_reported_count'];
    final int postType = data['post_type'];
    final int postViewCount = data['post_view_count'];
    final int postVisitedCount = data['post_visited_count'];
    final int postWrongCount = data['post_wrong_count'];
    final int postRightCount = data['Post_right_count'];
    final Null empty = data['empty'];


    return PostDetails(
      postIsDeleted: postIsDeleted,
      postAddedDate: postAddedDate,
      postAddedByUid: postAddedByUid,
      postAddedByPhoneNumber: postAddedByPhoneNumber,
      postImagePath: postImagePath,
      postLocation: postLocation,
      postTitle: postTitle,
      postDescription: postDescription,
      postUrl: postUrl,
      postReportedCount: postReportedCount,
      postType: postType,
      postViewCount: postViewCount,
      postVisitedCount: postVisitedCount,
      postWrongCount: postWrongCount,
      postRightCount: postRightCount,
      postID: postID,
      empty: empty,

    );
  }

  Map<String, dynamic> toMap(){
    return {
      postIsDeleted != null ? 'post_is_deleted': 'empty' : postIsDeleted,
      postAddedDate != null ? 'post_added_date':'empty' :  postAddedDate,
      postAddedByUid != null ? 'post_added_by_uid': 'empty' : postAddedByUid,
      postAddedByPhoneNumber != null ? 'post_added_by_phone_number': 'empty' : postAddedByPhoneNumber,
      postImagePath != null ? 'post_image_path': 'empty' : postImagePath,
      postLocation != null ? 'post_location': 'empty' : postLocation,
      postTitle != null ? 'post_title': 'empty' : postTitle,
      postDescription != null ? 'post_description': 'empty' : postDescription,
      postUrl != null ? 'post_url': 'empty' : postUrl,
      postReportedCount != null ? 'post_reported_count':'empty' :  postReportedCount,
      postType != null ? 'post_type': 'empty' : postType,
      postViewCount != null ? 'post_view_count': 'empty' : postViewCount,
      postVisitedCount != null ? 'post_visited_count': 'empty' : postVisitedCount,
      postWrongCount != null ? 'post_wrong_count': 'empty' : postWrongCount,
      postRightCount != null ? 'Post_right_count': 'empty' : postRightCount,
    };
  }
}