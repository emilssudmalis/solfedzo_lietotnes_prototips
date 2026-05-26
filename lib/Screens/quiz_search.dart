import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/Screens/quiz_details.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/app_widget.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/utils/quiz_constant.dart';
import 'package:quiz/utils/quiz_data_generator.dart';

class QuizSearch extends StatefulWidget {
  static String tag = '/QuizSearch';

  const QuizSearch({super.key});

  @override
  _QuizSearchState createState() => _QuizSearchState();
}

class _QuizSearchState extends State<QuizSearch> {
  late List<Topic> allTopics;
  late List<Topic> filteredTopics;
  var searchCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    allTopics = getTopics();
    filteredTopics = allTopics;
    searchCont.addListener(_filterTopics);
  }

  void _filterTopics() {
    setState(() {
      if (searchCont.text.isEmpty) {
        filteredTopics = allTopics;
      } else {
        filteredTopics = allTopics
            .where((topic) => topic.name.toLowerCase().contains(searchCont.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: quizappbackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              // Back button and search title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, size: 24).onTap(() {
                      finish(context);
                    }),
                    const SizedBox(width: 16),
                    text(
                      'Meklēt tēmas',
                      fontFamily: fontBold,
                      fontSize: textSizeXLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Search bar
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: boxDecoration(
                    radius: 10, showShadow: true, bgColor: quizwhite),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchCont,
                        decoration: InputDecoration(
                          hintText: 'Meklēt pēc nosaukuma...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: boxDecoration(
                          radius: 10,
                          showShadow: false,
                          bgColor: quizcolorPrimary),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.search, color: quizwhite),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Results count
              if (filteredTopics.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: text(
                    'Atrasts: ${filteredTopics.length} tēma${filteredTopics.length != 1 ? 's' : ''}',
                    textColor: quiztextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: text(
                    'Rezultāti nav atrasti',
                    textColor: quiztextColorSecondary,
                    fontSize: textSizeMedium,
                  ),
                ),
              const SizedBox(height: 16),
              // Grid of filtered topics
              if (filteredTopics.isNotEmpty)
                StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
                  scrollDirection: Axis.vertical,
                  itemCount: filteredTopics.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
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
                                filteredTopics[index].image,
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
                                    filteredTopics[index].name,
                                    fontSize: textSizeMedium,
                                    maxLine: 2,
                                    fontFamily: fontMedium,
                                  ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
                                  text(
                                    filteredTopics[index].description,
                                    textColor: quiztextColorSecondary,
                                  ).paddingOnly(left: 16, right: 16, bottom: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).onTap(() {
                      QuizDetails(selectedTopic: filteredTopics[index])
                          .launch(context);
                    });
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: quiztextColorSecondary,
                      ),
                      const SizedBox(height: 16),
                      text(
                        'Nav atrasta tēma ar šādu nosaukumu',
                        isCentered: true,
                        textColor: quiztextColorSecondary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
