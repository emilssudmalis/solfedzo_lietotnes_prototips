import 'package:just_audio/just_audio.dart';

/// Service to manage piano note sound playback
/// 
/// Uses just_audio package for cross-platform audio support (web, Android, iOS, etc.)
/// Add piano sound files to assets/sounds/piano/ with names like: C3.wav, C#3.wav, etc.
class PianoSoundService {
  static final PianoSoundService _instance = PianoSoundService._internal();
  final Map<int, AudioPlayer> _audioPlayers = {}; // One player per note
  bool _isInitialized = false;

  // Piano key layout: C3 to C5 (36 notes)
  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  PianoSoundService._internal();

  factory PianoSoundService() {
    return _instance;
  }

  /// Initialize the audio service and prepare audio sources
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Pre-load audio players for each note (C3 to C5 = 37 notes)
      for (int midiNote = 36; midiNote <= 72; midiNote++) {
        await _initializeNote(midiNote);
      }
      _isInitialized = true;
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
      // Try to set audio source - if file doesn't exist, it will fail gracefully
      try {
        await player.setAsset(assetPath);
        _audioPlayers[midiNote] = player;
      } catch (e) {
        // Audio file not found - dispose the player and continue
        await player.dispose();
        if (e.toString().contains('not found') || e.toString().contains('404')) {
          // File doesn't exist, that's okay
        } else {
          print('Error loading audio for ${_getMidiNoteName(midiNote)}: $e');
        }
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
  /// Requires audio files in assets/sounds/piano/ with names like: C3.wav, C#3.wav, etc.
  Future<void> playNote(int midiNote) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      if (_audioPlayers.containsKey(midiNote)) {
        AudioPlayer player = _audioPlayers[midiNote]!;
        // Reset to beginning and play
        await player.seek(Duration.zero);
        await player.play();
      }
    } catch (e) {
      print('Error playing sound for MIDI note $midiNote: $e');
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
      print('Error playing multiple notes: $e');
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
      print('Error disposing PianoSoundService: $e');
    }
  }
}
