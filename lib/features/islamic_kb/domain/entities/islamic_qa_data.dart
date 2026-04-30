import 'islamic_question.dart';

/// Curated Ibadah-only knowledge pool. Each entry is general guidance based
/// on widely-accepted Sunni positions; for personal rulings users are
/// directed to a qualified local scholar (the in-app disclaimer states this).
class IslamicQaData {
  IslamicQaData._();

  static const String universalDisclaimer =
      'General guidance for everyday practice — not a fatwa. For personal '
      'rulings, especially in cases of doubt or special circumstance, '
      'consult a qualified local scholar.';

  static const List<IslamicQuestion> all = <IslamicQuestion>[
    // ───── PRAYER (Salah) — 8 ─────
    IslamicQuestion(
      id: 'kb_001',
      category: KbCategory.prayer,
      questionEn: 'How do I perform wudu (ritual ablution)?',
      questionAr: 'كيف أتوضأ؟',
      answerEn:
          'Make the intention silently, say Bismillah, then: (1) wash both '
          'hands to the wrists three times; (2) rinse the mouth three times; '
          '(3) inhale and expel water from the nose three times; (4) wash '
          'the face from forehead-hairline to chin and ear-to-ear three '
          'times; (5) wash the right arm to the elbow three times, then the '
          'left; (6) wipe the head with wet hands once (and the ears, '
          'inner and outer); (7) wash the right foot to the ankle three '
          'times, then the left.',
      source:
          'Quran 5:6 ("O you who believe! When you rise to pray, wash…"); '
          'method described in Sahih al-Bukhari 159 and Sahih Muslim 226.',
      scholarlyNote:
          'Order and number of repetitions are similar across madhahib; '
          'small differences exist, e.g. wiping the entire head vs. part of '
          'it.',
    ),
    IslamicQuestion(
      id: 'kb_002',
      category: KbCategory.prayer,
      questionEn:
          'What are the five daily prayers and when are they performed?',
      questionAr: 'ما هي الصلوات الخمس وأوقاتها؟',
      answerEn:
          'Fajr — from true dawn until sunrise. Dhuhr — from when the sun '
          'has passed its zenith until an object\'s shadow equals its own '
          'length. Asr — from then until sunset. Maghrib — from sunset '
          'until the red twilight disappears. Isha — from the disappearance '
          'of twilight until midnight (or until true dawn). Each must be '
          'prayed within its time window.',
      source:
          'Quran 4:103 ("Prayer is enjoined on the believers at fixed times"); '
          'time windows from the Hadith of Jibril, Sunan Abi Dawud 393.',
    ),
    IslamicQuestion(
      id: 'kb_003',
      category: KbCategory.prayer,
      questionEn: 'How many rakats are in each daily prayer?',
      questionAr: 'كم عدد ركعات الصلوات الخمس؟',
      answerEn:
          'Fard (obligatory) rakats: Fajr 2, Dhuhr 4, Asr 4, Maghrib 3, '
          'Isha 4. The Prophet (peace be upon him) also prayed sunnah rakats '
          'around them; the most emphasised confirmed sunnahs are: 2 before '
          'Fajr, 4+2 around Dhuhr, 2 after Maghrib, 2 after Isha, plus the '
          'Witr at night.',
      source:
          'Sahih al-Bukhari 1182 and Sahih Muslim 728 on confirmed sunnahs.',
    ),
    IslamicQuestion(
      id: 'kb_004',
      category: KbCategory.prayer,
      questionEn: 'What invalidates wudu?',
      questionAr: 'ما الذي ينقض الوضوء؟',
      answerEn:
          'Anything that exits from the front or back passage (urine, '
          'stool, gas), deep sleep where awareness is lost, loss of '
          'consciousness (faint, drunkenness), and direct touching of '
          'private parts with the bare hand (per several madhahib).',
      source: 'Quran 5:6; Sahih al-Bukhari 137 (sleep + breaking of wind).',
      scholarlyNote:
          'Whether touching a non-mahram of the opposite sex breaks wudu '
          'is a known difference among the madhahib — this is one place to '
          'follow your local scholar.',
    ),
    IslamicQuestion(
      id: 'kb_005',
      category: KbCategory.prayer,
      questionEn: 'What are the conditions for the prayer to be valid?',
      questionAr: 'ما هي شروط صحة الصلاة؟',
      answerEn:
          'Be a Muslim, of sound mind, and (for prayers other than the '
          'mu\'allaq cases) past the age of discernment. Have wudu (or '
          'tayammum if water is unavailable). Cover the awrah, face the '
          'Qibla, pray in a clean place wearing clean clothes, within the '
          'time window, with the niyyah (intention) for that specific prayer.',
      source: 'Quran 2:144 (Qibla); 4:43 and 5:6 (purity); 4:103 (time).',
    ),
    IslamicQuestion(
      id: 'kb_006',
      category: KbCategory.prayer,
      questionEn: 'What do I do if I miss a prayer?',
      questionAr: 'ماذا أفعل إذا فاتتني صلاة؟',
      answerEn:
          'Pray it as soon as you remember, in its normal form. If you '
          'wake up after sunrise and missed Fajr, pray it then. The Prophet '
          '(peace be upon him) said: "Whoever forgets a prayer or sleeps '
          'through it, its expiation is to pray it when he remembers it."',
      source: 'Sahih al-Bukhari 597; Sahih Muslim 684.',
    ),
    IslamicQuestion(
      id: 'kb_007',
      category: KbCategory.prayer,
      questionEn: 'How do I pray when travelling?',
      questionAr: 'كيف أصلي في السفر؟',
      answerEn:
          'A traveller may shorten the four-rakat prayers (Dhuhr, Asr, Isha) '
          'to two rakats. Fajr and Maghrib remain unchanged. Combining Dhuhr '
          'with Asr, and Maghrib with Isha, in either of their times is also '
          'permitted on a journey.',
      source: 'Quran 4:101; Sahih Muslim 689 (shortening).',
      scholarlyNote:
          'Distance and duration thresholds for "travel" status differ '
          'among the madhahib; ~80 km is a common reference.',
    ),
    IslamicQuestion(
      id: 'kb_008',
      category: KbCategory.prayer,
      questionEn: 'May I pray anywhere as long as the place is clean?',
      questionAr: 'هل يجوز الصلاة في أي مكان طاهر؟',
      answerEn:
          'Yes. The Prophet (peace be upon him) said: "The earth has been '
          'made for me a place of prostration and a means of purification." '
          'Avoid places of impurity, graveyards, bathrooms, and other '
          'specifically forbidden spots. A small clean mat or piece of '
          'clean cloth on the ground is sufficient.',
      source: 'Sahih al-Bukhari 438; Sahih Muslim 521.',
    ),

    // ───── FASTING (Sawm) — 5 ─────
    IslamicQuestion(
      id: 'kb_009',
      category: KbCategory.fasting,
      questionEn: 'When and how do I make the intention for fasting Ramadan?',
      questionAr: 'متى وكيف أنوي صيام رمضان؟',
      answerEn:
          'Make the intention each night before Fajr to fast the next day '
          'for Allah. The intention is in the heart and need not be spoken '
          'aloud. A general intention at the start of Ramadan is widely held '
          'to be sufficient by some scholars, but renewing nightly is safer.',
      source:
          'Sunan Abi Dawud 2454: "Whoever does not have the intention of '
          'fasting before Fajr, his fast is not valid."',
    ),
    IslamicQuestion(
      id: 'kb_010',
      category: KbCategory.fasting,
      questionEn: 'What invalidates the fast?',
      questionAr: 'ما الذي يبطل الصوم؟',
      answerEn:
          'Eating or drinking intentionally, intentional vomiting, sexual '
          'intercourse during the day, the onset of menstrual or post-natal '
          'bleeding, and apostasy. If a person eats or drinks by genuine '
          'forgetfulness, the fast is not broken — they continue and Allah '
          'has fed them.',
      source:
          'Sahih al-Bukhari 1933 and Sahih Muslim 1155 (forgetful eating); '
          'Quran 2:187.',
    ),
    IslamicQuestion(
      id: 'kb_011',
      category: KbCategory.fasting,
      questionEn: 'Who is exempt from fasting in Ramadan?',
      questionAr: 'من يعفى من صيام رمضان؟',
      answerEn:
          'The sick whose illness fasting would harm, travellers, '
          'menstruating and post-natal women, the elderly who cannot fast, '
          'and pregnant or breastfeeding women if fasting harms them or the '
          'child. Most cases require making up the missed days later; the '
          'permanently incapable feed a poor person for each missed day '
          '(fidya).',
      source: 'Quran 2:184-185.',
    ),
    IslamicQuestion(
      id: 'kb_012',
      category: KbCategory.fasting,
      questionEn: 'What are suhoor and iftar?',
      questionAr: 'ما هو السحور والإفطار؟',
      answerEn:
          'Suhoor is the pre-dawn meal eaten before Fajr; the Prophet '
          '(peace be upon him) said: "Take suhoor — there is blessing in '
          'it." Iftar is breaking the fast at sunset (Maghrib). The sunnah '
          'is to break the fast promptly with fresh or dried dates and '
          'water, then pray Maghrib.',
      source:
          'Sahih al-Bukhari 1923 (blessing in suhoor); Sahih al-Bukhari 1957 '
          '(prompt iftar with dates).',
    ),
    IslamicQuestion(
      id: 'kb_013',
      category: KbCategory.fasting,
      questionEn:
          'What is fasting on the 10th of Muharram (the Day of Ashura)?',
      questionAr: 'ما هو صيام يوم عاشوراء؟',
      answerEn:
          'A highly recommended sunnah fast that expiates the sins of the '
          'previous year. The Prophet (peace be upon him) encouraged also '
          'fasting the 9th alongside the 10th to differ from the People of '
          'the Book.',
      source: 'Sahih Muslim 1162; 1134.',
    ),

    // ───── ZAKAT — 3 ─────
    IslamicQuestion(
      id: 'kb_014',
      category: KbCategory.zakat,
      questionEn: 'What is zakat and on whom is it obligatory?',
      questionAr: 'ما هي الزكاة وعلى من تجب؟',
      answerEn:
          'Zakat is the obligatory annual purification of wealth: every '
          'Muslim of full ownership over wealth that has reached the nisab '
          'and remained held for one lunar year pays a fixed share to '
          'specific categories of recipients. The most common form is 2.5% '
          'of cash and gold/silver after one Hijri year of holding.',
      source:
          'Quran 9:60 (recipients); 2:43; many hadiths including '
          'Sahih al-Bukhari 1395.',
    ),
    IslamicQuestion(
      id: 'kb_015',
      category: KbCategory.zakat,
      questionEn: 'What is the nisab (minimum threshold) for zakat?',
      questionAr: 'ما هو نصاب الزكاة؟',
      answerEn:
          'For gold, 85 grams. For silver, 595 grams. For cash, the '
          'equivalent value of either threshold (most contemporary scholars '
          'use the silver nisab to be more generous to the poor; many use '
          'gold). Below the nisab, no zakat is due.',
      source: 'Hadiths in Sahih al-Bukhari 1447 and Sunan al-Tirmidhi 620.',
      scholarlyNote:
          'Whether to use the gold or silver nisab for cash differs '
          'between scholars; both are valid choices.',
    ),
    IslamicQuestion(
      id: 'kb_016',
      category: KbCategory.zakat,
      questionEn: 'Who can receive zakat?',
      questionAr: 'من يستحق الزكاة؟',
      answerEn:
          'Eight categories named in the Quran: (1) the poor, (2) the '
          'needy, (3) those employed to administer the funds, (4) those '
          'whose hearts are to be reconciled, (5) freeing captives, '
          '(6) those in debt, (7) in the cause of Allah, (8) the wayfarer.',
      source: 'Quran 9:60.',
    ),

    // ───── HAJJ — 3 ─────
    IslamicQuestion(
      id: 'kb_017',
      category: KbCategory.hajj,
      questionEn: 'What conditions make Hajj obligatory upon a person?',
      questionAr: 'ما شروط وجوب الحج؟',
      answerEn:
          'Being Muslim, of sound mind, having reached puberty, being free, '
          'and having the physical and financial ability ("istita\'ah") to '
          'undertake the journey, including travel costs and provision for '
          'dependants left behind. For a woman, a mahram is also '
          'traditionally required for travel.',
      source:
          'Quran 3:97: "Hajj is a duty owed to Allah by those who can find '
          'a way to it."',
    ),
    IslamicQuestion(
      id: 'kb_018',
      category: KbCategory.hajj,
      questionEn: 'What are the major pillars of Hajj?',
      questionAr: 'ما أركان الحج؟',
      answerEn:
          'The pillars (without which Hajj is invalid) are: (1) Ihram — '
          'entering the sacred state with the intention; (2) Wuquf at '
          'Arafah on 9 Dhu al-Hijjah; (3) Tawaf al-Ifada around the Kaaba; '
          '(4) Sa\'i between Safa and Marwah. Other rites (stoning the '
          'jamarat, sacrifice, shaving) are obligatory but missing them '
          'requires expiation rather than invalidating the Hajj.',
      source: 'Sahih Muslim 1218 (the description of the Prophet\'s Hajj).',
    ),
    IslamicQuestion(
      id: 'kb_019',
      category: KbCategory.hajj,
      questionEn: 'What is the difference between Hajj and Umrah?',
      questionAr: 'ما الفرق بين الحج والعمرة؟',
      answerEn:
          'Hajj is the major pilgrimage performed in the first two weeks of '
          'Dhu al-Hijjah and is obligatory once in a lifetime for those '
          'able. Umrah ("the lesser pilgrimage") may be performed at any '
          'time of year and consists of Ihram, Tawaf, and Sa\'i, finishing '
          'with shaving or shortening the hair. Umrah is sunnah and '
          'highly recommended.',
      source:
          'Sahih al-Bukhari 1773 ("\'Umrah to \'Umrah is an expiation for '
          'what is between them, and the Hajj that is mabrur has no reward '
          'less than Paradise.").',
    ),

    // ───── CALENDAR & TIMES — 3 ─────
    IslamicQuestion(
      id: 'kb_020',
      category: KbCategory.calendar,
      questionEn: 'How are Islamic prayer times calculated?',
      questionAr: 'كيف تحسب مواقيت الصلاة؟',
      answerEn:
          'They are derived from the position of the sun: Fajr begins at '
          'true dawn (a defined angle below the horizon, typically 18°), '
          'Dhuhr at solar noon (after the sun passes its zenith), Asr when '
          'an object\'s shadow equals its own length (or twice for the '
          'Hanafi school), Maghrib at sunset, and Isha when twilight '
          'disappears (a defined angle, commonly 17°-18°).',
      source:
          'Hadith of Jibril, Sunan Abi Dawud 393; modern angle-based '
          'methods follow the same descriptions.',
    ),
    IslamicQuestion(
      id: 'kb_021',
      category: KbCategory.calendar,
      questionEn: 'When does Ramadan begin?',
      questionAr: 'متى يبدأ شهر رمضان؟',
      answerEn:
          'On the sighting of the new crescent moon (hilal) at the end of '
          'Sha\'ban. If the moon is not seen on the 29th of Sha\'ban, the '
          'month is completed as 30 days and Ramadan begins the next day. '
          'Many countries today use astronomical calculation to confirm '
          'sighting, but local moon-sighting committees remain authoritative.',
      source:
          'Sahih al-Bukhari 1909: "Fast when you see it [the crescent], '
          'and break the fast when you see it; if it is hidden from you, '
          'then complete the count of Sha\'ban as thirty days."',
    ),
    IslamicQuestion(
      id: 'kb_022',
      category: KbCategory.calendar,
      questionEn: 'What is the Hijri calendar?',
      questionAr: 'ما هو التقويم الهجري؟',
      answerEn:
          'A lunar calendar of 12 months totalling about 354 days. It '
          'begins from the year of the Prophet\'s emigration (Hijra) from '
          'Mecca to Medina (corresponding to 622 CE). Months begin with the '
          'sighting of the new crescent moon, so dates rotate ~11 days '
          'earlier each Gregorian year.',
      source:
          'Quran 9:36 ("The number of months with Allah is twelve…"); '
          'historical context in Sahih al-Bukhari 3934.',
    ),

    // ───── DAILY PRACTICES — 4 ─────
    IslamicQuestion(
      id: 'kb_023',
      category: KbCategory.daily,
      questionEn: 'What are morning and evening adhkar?',
      questionAr: 'ما هي أذكار الصباح والمساء؟',
      answerEn:
          'A set of authenticated supplications and rememberance recited '
          'after Fajr (morning) and after Asr/before Maghrib (evening). '
          'They include verses such as Ayat al-Kursi, the last three suras '
          'of the Quran (al-Ikhlas, al-Falaq, al-Nas — three times), and '
          'short formulas asking Allah for protection and well-being. The '
          'Adhkar feature in this app contains many of them.',
      source:
          'Compiled in works such as Hisn al-Muslim; individual du\'as are '
          'in Sahih al-Bukhari, Sahih Muslim, and Sunan al-Tirmidhi.',
    ),
    IslamicQuestion(
      id: 'kb_024',
      category: KbCategory.daily,
      questionEn: 'How much Quran should I read daily?',
      questionAr: 'كم أقرأ من القرآن يوميًا؟',
      answerEn:
          'There is no fixed obligation, but consistency is highly '
          'praised. Many companions and scholars recommended reciting at '
          'least one juz daily so the entire Quran is completed each month, '
          'with reflection rather than haste. Even a few verses with '
          'understanding is better than rushing many.',
      source:
          'Sahih Muslim 1849 ("The most beloved deeds to Allah are the '
          'most consistent, even if few"); Sahih al-Bukhari 5054 on Quran '
          'recitation in cycles of seven and thirty days.',
    ),
    IslamicQuestion(
      id: 'kb_025',
      category: KbCategory.daily,
      questionEn: 'What is the importance of duʿāʾ (supplication)?',
      questionAr: 'ما أهمية الدعاء؟',
      answerEn:
          'Duʿāʾ is the worshipper\'s direct conversation with Allah and is '
          'itself a form of worship. The Prophet (peace be upon him) said: '
          '"Duʿāʾ is worship." Best times include the last third of the '
          'night, while prostrating, between adhan and iqamah, and the last '
          'hour of Friday.',
      source: 'Sunan al-Tirmidhi 2969; Sahih Muslim 482.',
    ),
    IslamicQuestion(
      id: 'kb_026',
      category: KbCategory.daily,
      questionEn: 'What is the difference between sunnah and nafl prayers?',
      questionAr: 'ما الفرق بين السنة والنافلة؟',
      answerEn:
          'All prayers other than the five obligatory ones are voluntary. '
          'Within these, "sunnah mu\'akkadah" are the strongly emphasised '
          'sunnahs the Prophet (peace be upon him) practised regularly '
          '(e.g. 2 before Fajr, 2 after Maghrib). "Nafl" is general '
          'voluntary prayer beyond those, such as Duha, Tahajjud, and '
          'Tarawih during Ramadan.',
      source: 'Sahih Muslim 728; Sahih al-Bukhari 1182 on confirmed sunnahs.',
    ),

    // ───── EVERYDAY LIFE — 4 ─────
    IslamicQuestion(
      id: 'kb_027',
      category: KbCategory.everyday,
      questionEn: 'What basic foods are halal and which are clearly haram?',
      questionAr: 'ما الأطعمة الحلال والمحرمة بشكل أساسي؟',
      answerEn:
          'Halal: most foods are permitted by default. Meat from livestock '
          'slaughtered with the name of Allah is halal; seafood is halal; '
          'all clean plant-based foods are halal. Clearly haram: pork and '
          'its derivatives, blood, the meat of an animal that died of '
          'itself, animals slaughtered to other than Allah, intoxicants '
          '(alcohol and similar substances).',
      source: 'Quran 2:173; 5:3; 5:90.',
    ),
    IslamicQuestion(
      id: 'kb_028',
      category: KbCategory.everyday,
      questionEn: 'What is the basic Islamic guidance on modest dress?',
      questionAr: 'ما هي الضوابط الأساسية للباس في الإسلام؟',
      answerEn:
          'Both men and women cover their awrah and dress modestly. For men, '
          'the awrah is at minimum the area between the navel and the knee. '
          'For women in front of non-mahrams, the awrah is the entire body '
          'except commonly the face and hands; the head and chest are '
          'covered. Clothing should be loose, opaque, not imitating the '
          'opposite sex, and not extravagant.',
      source: 'Quran 24:30-31; 33:59; Sahih al-Bukhari 5546 on awrah.',
      scholarlyNote:
          'Specifics about face covering and what counts as "loose" '
          'differ among madhahib and cultural practice.',
    ),
    IslamicQuestion(
      id: 'kb_029',
      category: KbCategory.everyday,
      questionEn: 'What is the proper way to greet a Muslim?',
      questionAr: 'ما هي تحية الإسلام الصحيحة؟',
      answerEn:
          '"As-salamu alaykum" (Peace be upon you). The fuller form is '
          '"As-salamu alaykum wa rahmatullahi wa barakatuh" (Peace, mercy, '
          'and blessings of Allah be upon you). The reply is to use the same '
          'or a better form: "Wa alaykum as-salam wa rahmatullahi wa '
          'barakatuh."',
      source:
          'Quran 4:86 ("When you are greeted with a greeting, return one '
          'better than it or at least equivalent."); Sahih al-Bukhari 6234.',
    ),
    IslamicQuestion(
      id: 'kb_030',
      category: KbCategory.everyday,
      questionEn: 'May a Muslim pray while wearing shoes?',
      questionAr: 'هل يجوز الصلاة بالنعال؟',
      answerEn:
          'Yes, if the shoes are clean of impurity. The Prophet (peace be '
          'upon him) sometimes prayed in his sandals. In modern carpeted '
          'mosques the practice is to remove shoes to keep the prayer area '
          'clean for everyone, which is also good etiquette. At home or '
          'outdoors on clean ground, wearing clean shoes is permitted.',
      source:
          'Sahih al-Bukhari 386 and Sunan Abi Dawud 650 on praying in '
          'sandals; checking for impurity comes from Sunan Abi Dawud 650 '
          'as well.',
    ),
  ];

  static List<IslamicQuestion> forCategory(KbCategory c) =>
      all.where((q) => q.category == c).toList(growable: false);

  static IslamicQuestion? byId(String id) {
    for (final q in all) {
      if (q.id == id) return q;
    }
    return null;
  }
}
