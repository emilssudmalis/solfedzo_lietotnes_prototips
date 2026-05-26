import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/Screens/quiz_details.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/app_widget.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/utils/quiz_constant.dart';
import 'package:quiz/utils/quiz_data_generator.dart';

class QuizAllList extends StatefulWidget {
  static String tag = '/QuizAllList';

  const QuizAllList({super.key});

  @override
  _QuizAllListState createState() => _QuizAllListState();
}

class _QuizAllListState extends State<QuizAllList> {
  late List<Topic> mListings;

  @override
  void initState() {
    super.initState();
    mListings = getTopics();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final quizAll = StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      scrollDirection: Axis.vertical,
      itemCount: mListings.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        changeStatusColor(quizappbackground);
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: commonCacheImageWidget(
                    mListings[index].image,
                    height: width * 0.4,
                    width: width * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                    color: quizwhite,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      text(
                        mListings[index].name,
                        fontSize: textSizeMedium,
                        maxLine: 2,
                        fontFamily: fontMedium,
                      ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
                      text(
                        mListings[index].description,
                        textColor: quiztextColorSecondary,
                      ).paddingOnly(left: 16, right: 16, bottom: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).onTap(() {
          QuizDetails(selectedTopic: mListings[index]).launch(context);
        });
      },
      //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.67, mainAxisSpacing: 16, crossAxisSpacing: 16),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: quizappbackground,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 40),
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.only(right: 8, left: 8),
                  child: quizAll,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
