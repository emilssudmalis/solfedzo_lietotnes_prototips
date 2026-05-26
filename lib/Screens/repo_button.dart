import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:quiz/utils/quiz_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoButton extends StatelessWidget {
  const RepoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'Check out the Repo',
      color: quizcolorPrimary,
      textStyle: boldTextStyle(color: quizwhite),
      shapeBorder: RoundedRectangleBorder(borderRadius: radius(10)),
      onTap: () async {
        final uri = Uri.parse('https://github.com/muhammad-fiaz/QuizApp-Flutter');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}
