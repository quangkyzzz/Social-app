import 'package:demo_x/theme/theme.dart';
import 'package:flutter/material.dart';

class TestDetailView extends StatefulWidget {
  const TestDetailView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const TestDetailView(),
      );

  @override
  State<TestDetailView> createState() => _TestDetailViewState();
}

class _TestDetailViewState extends State<TestDetailView> {
  @override
  Widget build(BuildContext context) {
    int? selectedOption = -1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Test',
          style: TextStyle(color: Pallete.blueColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            QuestionWidget(
              selectedOption: selectedOption,
              text1: 'Question 1',
            ),
            const SizedBox(height: 10),
            QuestionWidget(
              selectedOption: selectedOption,
              text1: 'Question 2',
            ),
            const SizedBox(height: 10),
            QuestionWidget(
              selectedOption: selectedOption,
              text1: 'Question 3',
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Pallete.blueColor,
                    border: Border.all(
                      width: 0,
                      color: Pallete.backgroundColor,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String text1;
  const QuestionWidget({
    super.key,
    required this.selectedOption,
    required this.text1,
  });

  final int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        color: Pallete.backgroundGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: Pallete.whiteColor,
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              text1,
              style: const TextStyle(color: Pallete.blackColor),
            ),
          ),
          ListTile(
            title: const Text('answer 1'),
            leading: Radio(
              activeColor: Pallete.blueColor,
              value: 1,
              groupValue: selectedOption,
              onChanged: (value) {
                // setState(() {
                //   selectedOption = value;
                // });
              },
            ),
          ),
          ListTile(
            title: const Text('answer 2'),
            leading: Radio(
              activeColor: Pallete.blueColor,
              value: 2,
              groupValue: selectedOption,
              onChanged: (value) {
                // setState(() {
                //   selectedOption = value;
                // });
              },
            ),
          ),
          ListTile(
            title: const Text('answer 3'),
            leading: Radio(
              activeColor: Pallete.blueColor,
              value: 3,
              groupValue: selectedOption,
              onChanged: (value) {
                // setState(() {
                //   selectedOption = value;
                // });
              },
            ),
          ),
          ListTile(
            title: const Text('answer 4'),
            leading: Radio(
              activeColor: Pallete.blueColor,
              value: 4,
              groupValue: selectedOption,
              onChanged: (value) {
                // setState(() {
                //   selectedOption = value;
                // });
              },
            ),
          ),
        ],
      ),
    );
  }
}
