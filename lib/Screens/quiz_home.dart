import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/Screens/loading_screen.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/app_widget.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/utils/quiz_constant.dart';
import 'package:quiz/utils/quiz_data_generator.dart';
import 'package:quiz/utils/quiz_strings.dart';
import 'package:quiz/utils/learning_service.dart';

class QuizHome extends StatefulWidget {
  static String tag = '/QuizHome';

  const QuizHome({super.key});

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  late List<Topic> mListings;
  late List<Topic> filteredListings;
  int? expandedIndex;
  late TextEditingController searchController;
  late LearningService _learningService;

  @override
  void initState() {
    super.initState();
    mListings = getTopics();
    filteredListings = mListings;
    searchController = TextEditingController();
    searchController.addListener(_filterTopics);
    _learningService = LearningService();
    _learningService.initialize();
  }

  void _filterTopics() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredListings = mListings;
      } else {
        filteredListings = mListings
            .where((topic) => topic.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget buildTopicCard(Topic topic, int index, {required bool showProgress}) {
    final bool expanded = expandedIndex == index;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: quizwhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: quiztextColorSecondary.withAlpha((0.08 * 255).round()),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: commonCacheImageWidget(
                topic.image,
                height: MediaQuery.of(context).size.width * 0.4,
                width: MediaQuery.of(context).size.width * 0.25,
                fit: BoxFit.cover,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  color: quizwhite,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text(
                      topic.name,
                      fontSize: textSizeMedium,
                      maxLine: 2,
                      fontFamily: fontMedium,
                    ).paddingOnly(top: 16, left: 16, right: 16, bottom: 8),
                    if (expanded) ...[
                      text(
                        topic.description,
                        textColor: quiztextColorSecondary,
                        isLongText: true,
                      ).paddingOnly(left: 16, right: 16, bottom: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoadingScreen(topic: topic),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: quizcolorPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: text(
                            _learningService.hasStartedTopic(topic.id) ? 'Turpināt' : 'Sākt',
                            textColor: white,
                          ),
                        ),
                      ),
                      if (showProgress) ...[
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: textSecondaryColor.withAlpha(51),
                          valueColor: const AlwaysStoppedAnimation<Color>(quizgreen),
                        ).paddingOnly(left: 16, right: 16),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).onTap(() {
      setState(() {
        expandedIndex = expanded ? null : index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizAll = StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      scrollDirection: Axis.vertical,
      itemCount: filteredListings.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        changeStatusColor(quizappbackground);
        return buildTopicCard(filteredListings[index], index, showProgress: false);
      },
    );

    return Scaffold(
      backgroundColor: quizappbackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              text(quizlblhiantonio,
                  fontFamily: fontBold, fontSize: textSizeXLarge),
              text(quizlblwhatwouldyouliketolearnntodaysearchbelow,
                  textColor: quiztextColorSecondary,
                  isLongText: true,
                  isCentered: true),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: boxDecoration(
                    radius: 10, showShadow: true, bgColor: quizwhite),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: quizlblsearch,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (searchController.text.isEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: text(
                    quizlblAll,
                    fontSize: textSizeLargeMedium,
                    fontFamily: fontBold,
                    textColor: quiztextColorPrimary,
                  ).paddingOnly(left: 16, bottom: 12),
                ),
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

// ignore: must_be_immutable
class NewQuiz extends StatelessWidget {
  late Topic model;

  NewQuiz(this.model, int pos, {super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration:
          boxDecoration(radius: 16, showShadow: true, bgColor: quizwhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                child: commonCacheImageWidget(
                  model.image,
                  height: w * 0.4,
                  width: MediaQuery.of(context).size.width * 0.75,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    text(model.name,
                        fontSize: textSizeMedium,
                        isLongText: true,
                        fontFamily: fontMedium,
                        isCentered: false),
                    text(model.description, textColor: quiztextColorSecondary),
                  ],
                ),
                const Icon(Icons.arrow_forward, color: quiztextColorSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
