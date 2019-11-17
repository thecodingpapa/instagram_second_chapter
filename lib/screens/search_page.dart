import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/utils/profile_img_path.dart';

class SearchPage extends StatelessWidget {

  final List<String> users = List.generate(10, (i)=>'user $i');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return _item(users[index]);
          },
      separatorBuilder: (context, index){
            return Divider(thickness: 1,color: Colors.grey[300],);
      },),
    );
  }

  ListTile _item(String user) {
    return ListTile(
      leading: CircleAvatar(
        radius: profile_radius,
        backgroundImage: NetworkImage(getProfileImgPath(user)),
      ),
      title: Text(user),
      subtitle: Text('this is $user bio.'),
      trailing: Container(
          height: 30,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.black54, width: 0.5),
              borderRadius: BorderRadius.circular(6)),
          child: Text(
            'following',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red[700]),
          )),
    );
  }

}
