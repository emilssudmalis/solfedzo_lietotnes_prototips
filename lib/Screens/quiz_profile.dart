import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/Screens/repo_screen.dart';
import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/app_widget.dart';
import 'package:quiz/utils/learning_service.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:quiz/utils/quiz_constant.dart';
import 'package:quiz/utils/quiz_images.dart';
import 'package:quiz/utils/quiz_strings.dart';

class QuizProfile extends StatefulWidget {
  static String tag = '/QuizProfile';

  const QuizProfile({super.key});

  @override
  _QuizProfileState createState() => _QuizProfileState();
}

class _QuizProfileState extends State<QuizProfile> {
  late LearningService _learningService;
  late List<QuizBadgesModel> mList;

  @override
  void initState() {
    super.initState();
    _learningService = LearningService();
    mList = [];
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    await _learningService.initialize();
    setState(() {
      mList = _buildAchievementBadges();
    });
  }

  List<QuizBadgesModel> _buildAchievementBadges() {
    final List<QuizBadgesModel> badges = [];
    if (_learningService.isMastered('intervals_tercas')) {
      QuizBadgesModel badge = QuizBadgesModel();
      badge.title = 'Tercu meistars';
      badge.subtitle = 'Pabeigti visi 3 līmeņi tēmā "Tercas"';
      badge.img = tercaBilde;
      badges.add(badge);
    }
    return badges;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    final imgview = Container(
      color: quizappbackground,
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Container(
                height: width * 0.35,
                width: width * 0.35,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: quizwhite, width: 4)),
                child: CircleAvatar(backgroundImage: const AssetImage(quizimgPeople2), radius: MediaQuery.of(context).size.width / 8.5),
              ),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: quizwhite, width: 2), color: quizwhite),
                child: const Icon(Icons.edit, size: 20).onTap(() {
                 const RepoScreen(enableAppbar: true).launch(context);
                }),
              ).paddingOnly(right: 16, top: 16).onTap(() {
                debugPrint("Edit profile");
              })
            ],
          ),
          text(quizlbl, textColor: quiztextColorPrimary, fontSize: textSizeLargeMedium, fontFamily: fontBold).paddingOnly(top: 24),
          
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: text(
              'Balvas',
              fontSize: textSizeLargeMedium,
              fontFamily: fontBold,
              textColor: quiztextColorPrimary,
            ).paddingOnly(left: 16, bottom: 8),
          ),
          Container(
            decoration: boxDecoration(bgColor: quizwhite, radius: 10, showShadow: true),
            width: MediaQuery.of(context).size.width - 32,
            child: mList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: text(
                      'Pagaidām vēl neesi saņēmis nevienu balvu',
                      fontSize: textSizeMedium,
                      textColor: quiztextColorSecondary,
                      maxLine: 3,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: mList.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              commonCacheImageWidget(
                                mList[index].img,
                                height: 50,
                                width: 50,
                              ).paddingOnly(right: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[text(mList[index].title, fontFamily: fontMedium, textColor: quiztextColorPrimary), text(mList[index].subtitle, textColor: quiztextColorSecondary)],
                              ),
                            ],
                          ).paddingAll(8),
                        )),
          ).paddingOnly(bottom: 16)
        ],
      ),
    ).center();

    final resetButton = Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sākt no jauna'),
                content: const Text(
                  'Vai esi pārliecināts, ka vēlies atiestatīt visu savu progresu? Šo darbību nevar atsaukt.',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Atcelt'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _learningService.initialize();
                      await _learningService.resetAllProgress();
                      if (!mounted) return;
                      await _loadAchievements();
                      if (context.mounted) {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Pabeigts'),
                              content: const Text('Jūsu progress ir atiestatīts.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Labi'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Atiestatīt',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Text(
          'Sākt no jauna',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );

    changeStatusColor(quizappbackground);

    return SafeArea(
      child: Scaffold(
        backgroundColor: quizappbackground,
        appBar: AppBar(
          leading: Container(),
          backgroundColor: quizappbackground,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          physics:const ScrollPhysics(),
          child: Container(
            color: quizappbackground,
            child: Column(
              children: [
                imgview,
                resetButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
