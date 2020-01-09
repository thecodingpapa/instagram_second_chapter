import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/data/provider/my_user_data.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/firebase/firestore_provider.dart';
import 'package:instagram_thecodingpapa/utils/profile_img_path.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  final List<String> users = List.generate(10, (i) => 'user $i');

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>(
      create: (context) => firestoreProvider.fetchAllUsersExceptMine(),
      child: Consumer<List<User>>(
        builder: (context, userList, child) {
          return SafeArea(
            child: ListView.separated(
              itemCount: userList == null ? 0 : userList.length,
              itemBuilder: (context, index) {
                User user = userList[index];
                return _item(user);
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _item(User user) {
    return Consumer<MyUserData>(
      builder: (context, myUserData, child) {
        bool isFollowing = myUserData.amIFollowingThisUser(user.userKey);
        return ListTile(
          onTap: () {
            isFollowing
                ? firestoreProvider.unfollowUser(
                    myUserKey: myUserData.data.userKey,
                    otherUserKey: user.userKey)
                : firestoreProvider.followUser(
                    myUserKey: myUserData.data.userKey,
                    otherUserKey: user.userKey);
          },
          leading: CircleAvatar(
            radius: profile_radius,
            backgroundImage: NetworkImage(getProfileImgPath(user.username)),
          ),
          title: Text(user.username),
          subtitle: Text(user.email),
          trailing: Container(
              height: 30,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isFollowing ? Colors.blue[50] : Colors.red[50],
                  border: Border.all(color: Colors.black54, width: 0.5),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(
                isFollowing ? "following" : "not yet",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isFollowing ? Colors.blue[700] : Colors.red[700]),
              )),
        );
      },
    );
  }
}
