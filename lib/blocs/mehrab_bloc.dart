import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_times.dart';

// --- Events ---
abstract class MehrabEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeMehrabEvent extends MehrabEvent {}

class UpdateLocationEvent extends MehrabEvent {
  final double lat;
  final double lng;
  const UpdateLocationEvent(this.lat, this.lng);
}

class RecordKidsPrayerEvent extends MehrabEvent {
  final String prayerName;
  const RecordKidsPrayerEvent(this.prayerName);
}

class AskSpiritualGuideEvent extends MehrabEvent {
  final String userInput;
  const AskSpiritualGuideEvent(this.userInput);
}

class UpdateKhatmaPlanEvent extends MehrabEvent {
  final int days;
  const UpdateKhatmaPlanEvent(this.days);
}

class ScrollKhatmaProgressEvent extends MehrabEvent {
  final int pagesCompleted;
  const ScrollKhatmaProgressEvent(this.pagesCompleted);
}

// --- State ---
class MehrabState extends Equatable {
  final double latitude;
  final double longitude;
  final DailyPrayerTimes prayerTimes;
  final Map<String, bool> kidsPrayers;
  final int kidsPoints;
  final List<Map<String, String>> guideChat;
  final bool isGuideLoading;
  final int khatmaTargetDays;
  final int khatmaCompletedPages;
  final double qiblaAngle;

  const MehrabState({
    required this.latitude,
    required this.longitude,
    required this.prayerTimes,
    required this.kidsPrayers,
    required this.kidsPoints,
    required this.guideChat,
    required this.isGuideLoading,
    required this.khatmaTargetDays,
    required this.khatmaCompletedPages,
    required this.qiblaAngle,
  });

  factory MehrabState.initial() {
    return MehrabState(
      latitude: 21.4225, // Default near Holy Makkah
      longitude: 39.8262,
      prayerTimes: DailyPrayerTimes.calculate(21.4225, 39.8262, 3.0),
      kidsPrayers: const {"Fajr": false, "Dhuhr": false, "Asr": false, "Maghrib": false, "Isha": false},
      kidsPoints: 0,
      guideChat: const [],
      isGuideLoading: false,
      khatmaTargetDays: 30,
      khatmaCompletedPages: 0,
      qiblaAngle: 0.0,
    );
  }

  MehrabState copyWith({
    double? latitude,
    double? longitude,
    DailyPrayerTimes? prayerTimes,
    Map<String, bool>? kidsPrayers,
    int? kidsPoints,
    List<Map<String, String>>? guideChat,
    bool? isGuideLoading,
    int? khatmaTargetDays,
    int? khatmaCompletedPages,
    double? qiblaAngle,
  }) {
    return MehrabState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      kidsPrayers: kidsPrayers ?? this.kidsPrayers,
      kidsPoints: kidsPoints ?? this.kidsPoints,
      guideChat: guideChat ?? this.guideChat,
      isGuideLoading: isGuideLoading ?? this.isGuideLoading,
      khatmaTargetDays: khatmaTargetDays ?? this.khatmaTargetDays,
      khatmaCompletedPages: khatmaCompletedPages ?? this.khatmaCompletedPages,
      qiblaAngle: qiblaAngle ?? this.qiblaAngle,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        prayerTimes,
        kidsPrayers,
        kidsPoints,
        guideChat,
        isGuideLoading,
        khatmaTargetDays,
        khatmaCompletedPages,
        qiblaAngle,
      ];
}

// --- BLoC ---
class MehrabBloc extends Bloc<MehrabEvent, MehrabState> {
  final SharedPreferences prefs;

  MehrabBloc(this.prefs) : super(MehrabState.initial()) {
    on<InitializeMehrabEvent>(_onInitialize);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<RecordKidsPrayerEvent>(_onRecordKidsPrayer);
    on<AskSpiritualGuideEvent>(_onAskSpiritualGuide);
    on<UpdateKhatmaPlanEvent>(_onUpdateKhatmaPlan);
    on<ScrollKhatmaProgressEvent>(_onScrollKhatmaProgress);
  }

  void _onInitialize(InitializeMehrabEvent event, Emitter<MehrabState> emit) {
    double savedLat = prefs.getDouble('lat') ?? 21.4225;
    double savedLng = prefs.getDouble('lng') ?? 39.8262;
    int points = prefs.getInt('kids_pts') ?? 0;
    int kDays = prefs.getInt('khatma_days') ?? 30;
    int kPages = prefs.getInt('khatma_pages') ?? 0;

    // Calculate Qibla bearing
    double qibla = _calculateQibla(savedLat, savedLng);

    emit(state.copyWith(
      latitude: savedLat,
      longitude: savedLng,
      prayerTimes: DailyPrayerTimes.calculate(savedLat, savedLng, 3.0),
      kidsPoints: points,
      khatmaTargetDays: kDays,
      khatmaCompletedPages: kPages,
      qiblaAngle: qibla,
    ));
  }

  void _onUpdateLocation(UpdateLocationEvent event, Emitter<MehrabState> emit) {
    prefs.setDouble('lat', event.lat);
    prefs.setDouble('lng', event.lng);
    double qibla = _calculateQibla(event.lat, event.lng);

    emit(state.copyWith(
      latitude: event.lat,
      longitude: event.lng,
      prayerTimes: DailyPrayerTimes.calculate(event.lat, event.lng, 3.0),
      qiblaAngle: qibla,
    ));
  }

  void _onRecordKidsPrayer(RecordKidsPrayerEvent event, Emitter<MehrabState> emit) {
    final updated = Map<String, bool>.from(state.kidsPrayers);
    bool wasChecked = updated[event.prayerName] ?? false;
    updated[event.prayerName] = !wasChecked;
    
    int pointsIncrement = !wasChecked ? 10 : -10;
    int finalPoints = state.kidsPoints + pointsIncrement;
    if (finalPoints < 0) finalPoints = 0;

    prefs.setInt('kids_pts', finalPoints);

    emit(state.copyWith(
      kidsPrayers: updated,
      kidsPoints: finalPoints,
    ));
  }

  Future<void> _onAskSpiritualGuide(AskSpiritualGuideEvent event, Emitter<MehrabState> emit) async {
    final updatedChat = List<Map<String, String>>.from(state.guideChat);
    updatedChat.add({"role": "user", "text": event.userInput});
    emit(state.copyWith(guideChat: updatedChat, isGuideLoading: true));

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'YOUR_SECURE_API_KEY');
      final prompt = "You are Mehrab, an expert Quranic expert & digital spiritual guide. The user is experiencing: '${event.userInput}'. "
          "Provide structured comfort: 1) One highly relevant Quran verse in Arabic and translation. 2) A targeted, emotional Dua. 3) Contextual translations in English. Keep it comforting, warm, and brief.";
      
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      updatedChat.add({"role": "guide", "text": response.text ?? "A connection error occurred. Keep reciting your Dhikr."});
    } catch (e) {
      updatedChat.add({"role": "guide", "text": "I am standing by. To query the server, please ensure your AI API Key is configured. Here is a comfort verse: 'Indeed, with hardship comes ease.' (Quran 94:6)"});
    }

    emit(state.copyWith(guideChat: updatedChat, isGuideLoading: false));
  }

  void _onUpdateKhatmaPlan(UpdateKhatmaPlanEvent event, Emitter<MehrabState> emit) {
    prefs.setInt('khatma_days', event.days);
    emit(state.copyWith(khatmaTargetDays: event.days));
  }

  void _onScrollKhatmaProgress(ScrollKhatmaProgressEvent event, Emitter<MehrabState> emit) {
    int total = state.khatmaCompletedPages + event.pagesCompleted;
    if (total > 604) total = 604;
    if (total < 0) total = 0;

    prefs.setInt('khatma_pages', total);
    emit(state.copyWith(khatmaCompletedPages: total));
  }

  double _calculateQibla(double lat, double lng) {
    // Makkah Coordinates: lat 21.4225, lon 39.8262
    double latRad = lat * pi / 180.0;
    double lngRad = lng * pi / 180.0;
    double mLatRad = 21.4225 * pi / 180.0;
    double mLngRad = 39.8262 * pi / 180.0;

    double dLng = mLngRad - lngRad;
    double y = sin(dLng);
    double x = cos(latRad) * tan(mLatRad) - sin(latRad) * cos(dLng);
    double qiblaRad = atan2(y, x);
    return (qiblaRad * 180.0 / pi + 360.0) % 360.0;
  }
}
