import 'package:demo_x/common/common.dart';
import 'package:demo_x/features/home/test_detail.dart';
import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestView extends ConsumerStatefulWidget {
  const TestView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const TestView(),
      );

  @override
  ConsumerState<TestView> createState() => _TestViewState();
}

class _TestViewState extends ConsumerState<TestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Pallete.backgroundGreyColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const NewWidget(
              avatar: 'https://i.imgur.com/CbhBdjn.png',
              name: 'Test 1',
              text1: 'week 1 test',
              text2: 'By: @quangzzz',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Pallete.backgroundGreyColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const NewWidget(
              avatar: 'https://i.imgur.com/Axkr3cE.jpg',
              name: 'Test 2',
              text1: 'week 2 test',
              text2: 'By: @testmail',
            ),
          )
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  final String avatar;
  final String name;
  final String text1;
  final String text2;
  const NewWidget({
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
        Navigator.push(context, TestDetailView.route());
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
