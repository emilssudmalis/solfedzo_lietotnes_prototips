import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/quiz_images.dart';

import 'package:quiz/model/quiz_models.dart';
import 'package:quiz/utils/quiz_images.dart';

// Tercas fun facts
final tercaFacts = [
  'Vienas nots izmaiņa tercā var pārvērst dziesmas noskaņu no priecīgas uz skumju!',
  'Ja nevari atcerēties, kā izklausā maza terca, iedomājies dzeguzes kūkošanu!',
  'L. van Bēthovena slavenā 5. simfonija sākas ar lejupejošu lielas tercas gājienu: Sol-Sol-Sol-Mib!',
];

String getRandomTercaFact() {
  final facts = tercaFacts;
  return facts[DateTime.now().microsecond % facts.length];
}

List<Topic> getTopics() {
  List<Topic> topics = [];
  Topic topic1 = Topic(
    id: 'intervals_tercas',
    name: 'Tercas',
    description: 'Apgūsim lielas un mazas tercas!',
    image: tercaBilde,
    fact: 'Terces ir pamats harmonijai mūzikā.',
    facts: tercaFacts,
    goal: 'Pareizi identificēt lielo un mazo tercu intervālus.',
    theoryText:
        '''KAS IR TERCA?

Terca (no latīņu  valodas "tertius" - "trešais") ir intervāls, kura virsotne attiecībā pret pamatni ir trešā pakāpe.

To apzīmē ar ciparu "3".

TERCU VEIDI

1. LIELA TERCA (l3)
   • Attālums: 2 veseli toņi jeb 4 pustoņi (trīs klavieru taustiņi starpā)
   • Skaņa: Gaiša, priecīga
   • Piemēri:
     - Do - Mi
     - Re - Fa#
     - Mi - Sol#
[IMAGE_HERE]
2. MAZA TERCA (m3)
   • Attālums: pusotrs tonis jeb 3 pustoņi (divi klavieru taustiņi starpā)
   • Skaņa: Bēdīga, maiga
   • Piemēri:
     - Do - Mib
     - Re - Fa
     - Mi - Sol

TERCU STRUKTŪRA

Tercas pamatne = apakšējā nots
Tercas virsotne = trešā pakāpe attiecībā pret pamatni

Piemērs: Do-Mi tercu pārī
- Do = pamatne (1. pakāpe)
- Mi = virsotne (3. pakāpe)

TERCU NOZĪME MŪZIKĀ

- Liela terca + maza terca = Mažora trijskanis
- Maza terca + liela terca = Minora trijskanis

''',
    theoryImages: ['images/quiz/terca.png'],
    categories: ['intervals'],
  );
  Topic topic2 = Topic(
    id: 'intervals_kvartas',
    name: 'Kvartas',
    description: 'Apgūsim tīras un palielinātas kvartas!',
    image: kvartaBilde,
    fact: 'Drīzumā būs pieejama pilna informācija.',
    goal: 'Tēma vēl tiek izstrādāta.',
    theoryText:
        'Šis ir teorijas piemērs\n\nŠī tēma vēl tiek izstrādāta. Drīzumā šeit būs pilna informācija par kvartām.\n\nLūdzu, atgriezieties vēlāk!',
    theoryImages: [],
    categories: ['intervals'],
  );
  Topic topic3 = Topic(
    id: 'intervals_kvintas',
    name: 'Kvintas',
    description: 'Apgūsim tīras un pamazinātas kvintas!',
    image: kvintaBilde,
    fact:
        'Drīzumā būs pieejama pilna informācija.',
    goal: 'Tēma vēl tiek izstrādāta.',
    theoryText:
        'Šis ir teorijas piemērs\n\nŠī tēma vēl tiek izstrādāta. Drīzumā šeit būs pilna informācija par kvintām.\n\nLūdzu, atgriezieties vēlāk!',
    theoryImages: [],
    categories: ['intervals'],
  );
  Topic topic4 = Topic(
    id: 'intervals_sekstas',
    name: 'Sekstas',
    description: 'Apgūsim lielas un mazas sekstas!',
    image: sekstaBilde,
    fact: 'Drīzumā būs pieejama pilna informācija.',
    goal: 'Tēma vēl tiek izstrādāta.',
    theoryText:
        'Šis ir teorijas piemērs\n\nŠī tēma vēl tiek izstrādāta. Drīzumā šeit būs pilna informācija par sekstām.\n\nLūdzu, atgriezieties vēlāk!',
    theoryImages: [],
    categories: ['intervals'],
  );
  topics.add(topic1);
  topics.add(topic2);
  topics.add(topic3);
  topics.add(topic4);
  return topics;
}

List<QuizTestModel> quizGetData() {
  List<QuizTestModel> list = [];
  QuizTestModel model1 = QuizTestModel();
  model1.heading = "The Scientific Method";
  model1.image = quizicquiz1;
  model1.type = "Quiz 1";
  model1.description = "Let's put your memory on our first topic to test.";
  model1.status = "true";

  QuizTestModel model2 = QuizTestModel();
  model2.heading = "Introduction to Biology";
  model2.image = quizicquiz2;
  model2.type = "Flashcards";
  model2.description = "Complete the above test to unlock this one.";
  model2.status = "false";

  QuizTestModel model3 = QuizTestModel();
  model3.heading = "Controlled Experiments";
  model3.image = quizicquiz1;
  model3.type = "Quiz 2";
  model3.description = "Let's put your memory on our first topic to test.";
  model3.status = "false";

  list.add(model1);
  list.add(model2);
  list.add(model3);

  return list;
}

List<QuizBadgesModel> quizBadgesData() {
  List<QuizBadgesModel> list = [];
  QuizBadgesModel model1 = QuizBadgesModel();
  model1.title = "Achiever";
  model1.subtitle = "Complete an exercise";
  model1.img = quiziclist2;

  QuizBadgesModel model2 = QuizBadgesModel();
  model2.title = "Perectionistf";
  model2.subtitle = "Finish All lesson of chapter";
  model2.img = quiziclist5;

  QuizBadgesModel model3 = QuizBadgesModel();
  model3.title = "Scholar";
  model3.subtitle = "Study two Cources";
  model3.img = quiziclist3;

  QuizBadgesModel model4 = QuizBadgesModel();
  model4.title = "Champion";
  model4.subtitle = "Finish #1 in Scoreboard";
  model4.img = quiziclist4;

  QuizBadgesModel model5 = QuizBadgesModel();
  model5.title = "Focused";
  model5.subtitle = "Study every day for 30 days";
  model5.img = quiziclist5;

  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);
  list.add(model5);

  return list;
}

List<QuizScoresModel> quizScoresData() {
  List<QuizScoresModel> list = [];
  QuizScoresModel model1 = QuizScoresModel();
  model1.title = "Tēma: tercas";
  model1.shortDescription = "20 Quiz";
  model1.img = quiziccourse1;
  model1.scores = "30/50";

  QuizScoresModel model2 = QuizScoresModel();
  model2.title = "Java Basics";
  model2.shortDescription = "30 Quiz";
  model2.img = quiziccourse2;
  model2.scores = "30/50";

  QuizScoresModel model3 = QuizScoresModel();
  model3.title = "Art & Painting Basics";
  model3.shortDescription = "10 Quiz";
  model3.img = quiziccourse3;
  model3.scores = "10/50";

  list.add(model1);
  list.add(model2);
  list.add(model3);

  return list;
}

List<QuizContactUsModel> quizContactUsData() {
  List<QuizContactUsModel> list = [];
  QuizContactUsModel model1 = QuizContactUsModel();
  model1.title = "Call Request";
  model1.subtitle = "+00 356 646 234";

  QuizContactUsModel model2 = QuizContactUsModel();
  model2.title = "Email";
  model2.subtitle = "Response within 24 business hours";

  list.add(model1);
  list.add(model2);

  return list;
}
