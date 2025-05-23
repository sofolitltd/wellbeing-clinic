import 'package:wellbeingclinic/test/database/dark_triad.dart';

import '../model/test_model.dart';
import 'database/depression.dart';
import 'database/gad.dart';
import 'database/hopelessness.dart';
import 'database/insomnia.dart';
import 'database/internet_addiction.dart';
import 'database/love_obsession.dart';
import 'database/nicotine_addiction.dart';
import 'database/ocd.dart';
import 'database/pss.dart';
import 'database/satisfaction_with_life.dart';
import 'database/self_esteem.dart';
import 'database/social_anxiety.dart';
import 'database/wellbeing.dart';

List<TestModel> testList = [
  ///
  //wellbeing
  TestModel(
    category: 'Wellbeing',
    title: Wellbeing.title,
    route: Wellbeing.route,
    about: Wellbeing.about,
    instruction: Wellbeing.instruction,
    author: Wellbeing.author,
    items: Wellbeing.items,
  ),

  //satisfaction with life
  TestModel(
    category: 'Wellbeing',
    title: SatisfactionWithLife.title,
    route: SatisfactionWithLife.route,
    about: SatisfactionWithLife.about,
    instruction: SatisfactionWithLife.instruction,
    author: SatisfactionWithLife.author,
    items: SatisfactionWithLife.items,
  ),

  // Self Esteem
  TestModel(
    category: 'Wellbeing',
    title: SelfEsteem.title,
    route: SelfEsteem.route,
    about: SelfEsteem.about,
    instruction: SelfEsteem.instruction,
    author: SelfEsteem.author,
    items: SelfEsteem.items,
  ),

  ///
  // depression
  TestModel(
    category: "Emotion",
    title: Depression.title,
    route: Depression.route,
    about: Depression.about,
    instruction: Depression.instruction,
    author: Depression.author,
    items: Depression.items,
  ),

  // social anxiety
  TestModel(
    category: 'Emotion',
    title: SocialAnxiety.title,
    route: SocialAnxiety.route,
    about: SocialAnxiety.about,
    instruction: SocialAnxiety.instruction,
    author: SocialAnxiety.author,
    items: SocialAnxiety.items,
  ),

  //perceived stress scale
  TestModel(
    category: 'Emotion',
    title: PSS.title,
    route: PSS.route,
    about: PSS.about,
    instruction: PSS.instruction,
    author: PSS.author,
    items: PSS.items,
  ),

  // hopelessness
  TestModel(
    category: 'Emotion',
    title: Hopelessness.title,
    route: Hopelessness.route,
    about: Hopelessness.about,
    instruction: Hopelessness.instruction,
    author: Hopelessness.author,
    items: Hopelessness.items,
  ),

  ///
  // ocd
  TestModel(
    category: 'Disorder',
    title: OCD.title,
    route: OCD.route,
    about: OCD.about,
    instruction: OCD.instruction,
    author: OCD.author,
    items: OCD.items,
  ),

  // gad
  TestModel(
    category: 'Disorder',
    title: GAD.title,
    route: GAD.route,
    about: GAD.about,
    instruction: GAD.instruction,
    author: GAD.author,
    items: GAD.items,
  ),

  //insomnia
  TestModel(
    category: 'Disorder',
    title: Insomnia.title,
    route: Insomnia.route,
    about: Insomnia.about,
    instruction: Insomnia.instruction,
    author: Insomnia.author,
    items: Insomnia.items,
  ),

  ///
  // love obsession
  TestModel(
    category: "Addiction",
    title: LoveObsession.title,
    route: LoveObsession.route,
    about: LoveObsession.about,
    instruction: LoveObsession.instruction,
    author: LoveObsession.author,
    items: LoveObsession.items,
  ),

  //nicotine addiction
  TestModel(
    category: 'Addiction',
    title: NicotineAddiction.title,
    route: NicotineAddiction.route,
    about: NicotineAddiction.about,
    instruction: NicotineAddiction.instruction,
    author: NicotineAddiction.author,
    items: NicotineAddiction.items,
  ),

  // internet addiction
  TestModel(
    category: 'Addiction',
    title: InternetAddiction.title,
    route: InternetAddiction.route,
    about: InternetAddiction.about,
    instruction: InternetAddiction.instruction,
    author: InternetAddiction.author,
    items: InternetAddiction.items,
  ),

  //
  // DarkTriad
  TestModel(
    category: 'Personality',
    title: DarkTriad.title,
    route: DarkTriad.route,
    about: DarkTriad.about,
    instruction: DarkTriad.instruction,
    author: DarkTriad.author,
    items: DarkTriad.items,
  ),
];
