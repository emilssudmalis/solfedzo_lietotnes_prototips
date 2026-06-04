import 'package:just_audio/just_audio.dart';

/// Service to manage piano note sound playback
/// 
/// Uses just_audio package for cross-platform audio support (web, Android, iOS, etc.)
/// Add piano sound files to assets/sounds/piano/ with names like: C4.wav, C#4.wav, D4.wav, etc.
/// Currently loads octave 4 (C4 to B4 = MIDI 60-71)
class PianoSoundService {
  static final PianoSoundService _instance = PianoSoundService._internal();
  final Map<int, AudioPlayer> _audioPlayers = {}; // One player per note
  bool _isInitialized = false;

  // Piano key layout: C4 to B4 (12 notes, one octave)
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  PianoSoundService._internal();

  factory PianoSoundService() {
    return _instance;
  }

  /// Preload all piano sounds in the background (call this early in app lifecycle)
  static void preloadAsync() {
    _instance.initialize();
  }

  /// Initialize the audio service and prepare audio sources
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Pre-load audio players for octave 4 - all 12 notes (C4 through B4)
      // MIDI: 60=C4, 61=C#4, 62=D4, 63=D#4, 64=E4, 65=F4, 66=F#4, 67=G4, 68=G#4, 69=A4, 70=A#4, 71=B4
      List<int> notesToLoad = [60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71];
      
      for (int midiNote in notesToLoad) {
        await _initializeNote(midiNote);
      }
      _isInitialized = true;
      print('PianoSoundService initialized. Loaded ${_audioPlayers.length} notes.');
    } catch (e) {
      print('Error initializing PianoSoundService: $e');
    }
  }

  /// Initialize a single note's audio player
  Future<void> _initializeNote(int midiNote) async {
    try {
      String noteName = _getMidiNoteName(midiNote);
      String assetPath = 'assets/sounds/piano/$noteName.wav';

      AudioPlayer player = AudioPlayer();
      try {
        await player.setAsset(assetPath);
        _audioPlayers[midiNote] = player;
        print('Loaded: $assetPath');
      } catch (e) {
        print('Failed to load $assetPath: $e');
        await player.dispose();
      }
    } catch (e) {
      print('Error initializing note $midiNote: $e');
    }
  }

  /// Get MIDI note name (e.g., "C3", "D#4")
  String _getMidiNoteName(int midiNote) {
    int octave = (midiNote ~/ 12) - 1;
    int noteIndex = midiNote % 12;
    return '${noteNames[noteIndex]}$octave';
  }

  /// Play a piano note sound by MIDI note number
  /// 
  /// Requires audio files in assets/sounds/piano/ with names like: C4.wav, D4.wav, E4.wav, etc.
  /// Supports octave 4 natural notes only (MIDI 60, 62, 64, 65, 67, 69, 71)
  Future<void> playNote(int midiNote) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_audioPlayers.containsKey(midiNote)) {
        AudioPlayer player = _audioPlayers[midiNote]!;
        
        try {
          // Stop any current playback without waiting
          if (player.playing) {
            player.stop();
          }
          // Reset to beginning and play immediately
          player.seek(Duration.zero);
          await player.play();
        } catch (e) {
          // Silently handle playback errors
        }
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Play multiple notes simultaneously (for chords)
  Future<void> playNotes(List<int> midiNotes) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Play all notes concurrently
      await Future.wait(
        midiNotes.map((note) => playNote(note)),
      );
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Dispose of all audio players
  Future<void> dispose() async {
    try {
      for (AudioPlayer player in _audioPlayers.values) {
        await player.dispose();
      }
      _audioPlayers.clear();
      _isInitialized = false;
    } catch (e) {
      // Silently handle disposal errors
    }
  }
}
