import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../quran/domain/entities/surah.dart';
import '../../data/repositories/quran_radio_repository.dart';
import '../../domain/entities/reciter.dart';

class QuranRadioController extends GetxController {
  QuranRadioController(this._repo);
  final QuranRadioRepository _repo;

  final AudioPlayer _player = AudioPlayer();

  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxList<Surah> surahs = <Surah>[].obs;
  final Rxn<Surah> currentSurah = Rxn<Surah>();
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  Reciter get reciter => _repo.reciter;
  AudioPlayer get audioPlayer => _player;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration?>? _durSub;
  StreamSubscription<Duration>? _posSub;
  Timer? _persistTimer;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
    _wirePlayerStreams();
  }

  @override
  void onClose() {
    _stateSub?.cancel();
    _durSub?.cancel();
    _posSub?.cancel();
    _persistTimer?.cancel();
    _player.dispose();
    super.onClose();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    try {
      surahs.value = await _repo.surahs();
    } catch (e) {
      errorMessage.value = 'Failed to load surahs: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _wirePlayerStreams() {
    _stateSub = _player.playerStateStream.listen((s) {
      isPlaying.value = s.playing;
      isBuffering.value =
          s.processingState == ProcessingState.buffering ||
          s.processingState == ProcessingState.loading;
      if (s.processingState == ProcessingState.completed) {
        next();
      }
    });
    _durSub = _player.durationStream.listen((d) {
      duration.value = d ?? Duration.zero;
    });
    _posSub = _player.positionStream.listen((p) {
      position.value = p;
    });
    _persistTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final s = currentSurah.value;
      if (s != null && _player.playing) {
        _repo.saveProgress(s.number, _player.position);
      }
    });
  }

  Future<void> play(Surah surah, {Duration startAt = Duration.zero}) async {
    currentSurah.value = surah;
    final url = _repo.streamingUrlFor(surah.number);
    final mediaItem = MediaItem(
      id: 'quran_${surah.number.toString().padLeft(3, '0')}',
      album: 'Quran Recitation — ${reciter.englishName}',
      title: '${surah.number}. ${surah.englishName}',
      artist: reciter.englishName,
      displayTitle:
          '${surah.number}. ${surah.englishName} '
          '(${surah.arabicName})',
      displaySubtitle: reciter.englishName,
    );
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(url), tag: mediaItem),
        initialPosition: startAt,
      );
      await _player.play();
      await _repo.saveProgress(surah.number, startAt);
    } catch (e) {
      errorMessage.value = 'Could not play surah ${surah.number}: $e';
    }
  }

  Future<void> resumeOrPlay(Surah surah) async {
    final last = _repo.lastPlayedSurah();
    final pos = _repo.lastPlayedPosition();
    if (last == surah.number && pos != null) {
      await play(surah, startAt: pos);
    } else {
      await play(surah);
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Future<void> next() async {
    final s = currentSurah.value;
    if (s == null) return;
    if (s.number >= 114) return;
    final nextS = surahs.firstWhere(
      (x) => x.number == s.number + 1,
      orElse: () => s,
    );
    await play(nextS);
  }

  Future<void> previous() async {
    final s = currentSurah.value;
    if (s == null) return;
    if (s.number <= 1) return;
    final prevS = surahs.firstWhere(
      (x) => x.number == s.number - 1,
      orElse: () => s,
    );
    await play(prevS);
  }

  /// Resume from the last persisted (surah, position) if any.
  Future<void> resumeLastIfAvailable() async {
    final lastNum = _repo.lastPlayedSurah();
    if (lastNum == null) return;
    final s = surahs.firstWhere(
      (x) => x.number == lastNum,
      orElse: () => surahs.isEmpty
          ? Surah(
              number: 0,
              arabicName: '',
              englishName: '',
              englishMeaning: '',
              revelationType: '',
              ayahCount: 0,
            )
          : surahs.first,
    );
    if (s.number == 0) return;
    await resumeOrPlay(s);
  }
}
