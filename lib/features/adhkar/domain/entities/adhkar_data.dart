import 'dhikr.dart';

class AdhkarData {
  AdhkarData._();

  static const List<Dhikr> all = <Dhikr>[
    // ───── MORNING ─────
    Dhikr(
      id: 'morning_sayyid_istighfar',
      category: DhikrCategory.morning,
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      transliteration:
          'Allāhumma anta rabbī, lā ilāha illā anta, khalaqtanī wa-anā ʿabduk…',
      translation:
          'O Allah, You are my Lord, none has the right to be worshipped but You. You created me and I am Your servant. I keep Your covenant and pledge to You as much as I can. I seek refuge in You from the evil I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me — for none can forgive sins except You.',
      source: 'Sayyid al-Istighfar — Sahih al-Bukhari 6306',
      count: 1,
    ),
    Dhikr(
      id: 'morning_asbahna_amsayna',
      category: DhikrCategory.morning,
      arabic:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      translation:
          'We have entered the morning and the kingdom belongs to Allah; praise belongs to Allah; there is no god but Allah alone, with no partner.',
      source: 'Sahih Muslim 2723',
      count: 1,
    ),
    Dhikr(
      id: 'morning_radhitu',
      category: DhikrCategory.morning,
      arabic:
          'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
      translation:
          'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet.',
      source: 'Sunan Abi Dawud 5072',
      count: 3,
    ),
    Dhikr(
      id: 'morning_bismillah_ladhi',
      category: DhikrCategory.morning,
      arabic:
          'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      translation:
          'In the name of Allah, with whose name nothing on earth or in the heaven can cause harm; He is the All-Hearing, All-Knowing.',
      source: 'Sunan Abi Dawud 5088',
      count: 3,
    ),
    Dhikr(
      id: 'morning_subhanallahi_wa_bihamdihi',
      category: DhikrCategory.morning,
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      translation: 'Glory is to Allah and praise is to Him.',
      source: 'Sahih Muslim 2692',
      count: 100,
    ),

    // ───── EVENING ─────
    Dhikr(
      id: 'evening_sayyid_istighfar',
      category: DhikrCategory.evening,
      arabic:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
      translation:
          'O Allah, You are my Lord, none has the right to be worshipped but You. You created me and I am Your servant. I keep Your covenant and pledge to You as much as I can. I seek refuge in You from the evil I have done. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me — for none can forgive sins except You.',
      source: 'Sayyid al-Istighfar — Sahih al-Bukhari 6306',
      count: 1,
    ),
    Dhikr(
      id: 'evening_asmsayna',
      category: DhikrCategory.evening,
      arabic:
          'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      translation:
          'We have entered the evening and the kingdom belongs to Allah; praise belongs to Allah; there is no god but Allah alone, with no partner.',
      source: 'Sahih Muslim 2723',
      count: 1,
    ),
    Dhikr(
      id: 'evening_radhitu',
      category: DhikrCategory.evening,
      arabic:
          'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
      translation:
          'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet.',
      source: 'Sunan Abi Dawud 5072',
      count: 3,
    ),
    Dhikr(
      id: 'evening_audhu_bikalimat',
      category: DhikrCategory.evening,
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      translation:
          'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      source: 'Sahih Muslim 2708',
      count: 3,
    ),
    Dhikr(
      id: 'evening_subhanallahi_wa_bihamdihi',
      category: DhikrCategory.evening,
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      translation: 'Glory is to Allah and praise is to Him.',
      source: 'Sahih Muslim 2692',
      count: 100,
    ),

    // ───── AFTER PRAYER ─────
    Dhikr(
      id: 'after_astaghfirullah_x3',
      category: DhikrCategory.afterPrayer,
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullāh',
      translation: 'I seek forgiveness from Allah.',
      source: 'Sahih Muslim 591',
      count: 3,
    ),
    Dhikr(
      id: 'after_allahumma_anta_assalam',
      category: DhikrCategory.afterPrayer,
      arabic:
          'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
      translation:
          'O Allah, You are Peace, and from You comes peace. Blessed are You, O Possessor of Majesty and Honour.',
      source: 'Sahih Muslim 591',
      count: 1,
    ),
    Dhikr(
      id: 'after_subhanallah_33',
      category: DhikrCategory.afterPrayer,
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'Subḥān-Allāh',
      translation: 'Glory is to Allah.',
      source: 'Sahih Muslim 596',
      count: 33,
    ),
    Dhikr(
      id: 'after_alhamdulillah_33',
      category: DhikrCategory.afterPrayer,
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Al-ḥamdu lillāh',
      translation: 'All praise is for Allah.',
      source: 'Sahih Muslim 596',
      count: 33,
    ),
    Dhikr(
      id: 'after_allahu_akbar_34',
      category: DhikrCategory.afterPrayer,
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allāhu akbar',
      translation: 'Allah is the Greatest.',
      source: 'Sahih Muslim 596',
      count: 34,
    ),
    Dhikr(
      id: 'after_la_ilaha_illallah',
      category: DhikrCategory.afterPrayer,
      arabic:
          'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      translation:
          'There is no god but Allah alone, with no partner. To Him belongs all sovereignty and praise, and He is over all things capable.',
      source: 'Sahih Muslim 593',
      count: 1,
    ),

    // ───── GENERAL TASBIH ─────
    Dhikr(
      id: 'tasbih_subhanallah',
      category: DhikrCategory.general,
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'Subḥān-Allāh',
      translation: 'Glory is to Allah.',
      source: 'General tasbih',
      count: 33,
    ),
    Dhikr(
      id: 'tasbih_alhamdulillah',
      category: DhikrCategory.general,
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Al-ḥamdu lillāh',
      translation: 'All praise is for Allah.',
      source: 'General tasbih',
      count: 33,
    ),
    Dhikr(
      id: 'tasbih_allahu_akbar',
      category: DhikrCategory.general,
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allāhu akbar',
      translation: 'Allah is the Greatest.',
      source: 'General tasbih',
      count: 34,
    ),
  ];

  static List<Dhikr> forCategory(DhikrCategory category) =>
      all.where((d) => d.category == category).toList(growable: false);
}
