class QuranVerse {
  final int number;
  final String arabic;
  final String translation;

  const QuranVerse({
    required this.number,
    required this.arabic,
    required this.translation,
  });
}

class QuranSurah {
  final int id;
  final String name;
  final String nameArabic;
  final int totalVerses;
  final List<QuranVerse> verses;

  const QuranSurah({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.totalVerses,
    required this.verses,
  });
}

const List<QuranSurah> staticQuranData = [
  QuranSurah(
    id: 1,
    name: "Al-Fatiha",
    nameArabic: "الفاتحة",
    totalVerses: 7,
    verses: [
      QuranVerse(number: 1, arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", translation: "In the name of Allah, the Entirely Merciful, the Especially Merciful."),
      QuranVerse(number: 2, arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", translation: "All praise is due to Allah, Lord of the worlds."),
    ],
  ),
  QuranSurah(
    id: 112,
    name: "Al-Ikhlas",
    nameArabic: "الإخلاص",
    totalVerses: 4,
    verses: [
      QuranVerse(number: 1, arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ", translation: "Say, 'He is Allah, [who is] One.'"),
      QuranVerse(number: 2, arabic: "اللَّهُ الصَّمَدُ", translation: "Allah, the Eternal Refuge."),
    ],
  ),
];
