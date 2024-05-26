import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/home/group_post.dart';
import 'package:demo_x/theme/theme.dart';
import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const GroupView(),
      );
  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Pallete.backgroundGreyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const NewWidget2(
                avatar: 'https://i.imgur.com/MdD8ybU.jpg',
                name: 'Group 1',
                text1: 'Description: group for math students',
                text2: 'Admin: @quangzzz',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Pallete.backgroundGreyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const NewWidget2(
                avatar: 'https://i.imgur.com/MdD8ybU.jpg',
                name: 'Group 2',
                text1: 'Description: group for physic students',
                text2: 'Admin: @quangzzz',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 5),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Pallete.backgroundGreyColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const NewWidget2(
                avatar: 'https://i.imgur.com/MdD8ybU.jpg',
                name: 'Group 3',
                text1: 'Description: for chemistry students',
                text2: 'Admin: @quangzzz',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewWidget2 extends StatelessWidget {
  final String avatar;
  final String name;
  final String text1;
  final String text2;
  const NewWidget2({
    super.key,
    required this.avatar,
    required this.name,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, GroupPostView.route());
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 30,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            text1,
            style: const TextStyle(
              color: Pallete.whiteColor,
              fontSize: 16,
            ),
          ),
          Text(
            text2,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
