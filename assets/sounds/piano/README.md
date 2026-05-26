# Piano Sounds Setup Guide

This directory contains piano note audio files for the validation tasks. When a user clicks a piano key, the corresponding audio file plays.

## Setup Steps

1. **Install dependencies** (if not already done):
   ```bash
   flutter pub get
   ```
   This installs the `just_audio` package which handles cross-platform audio playback.

2. **Add audio files** to this directory

## Audio File Naming Convention

Audio files should be named after their musical notes in the format: `{NOTE}{OCTAVE}.wav`

**Example filenames:**
- `C3.wav` - Middle C
- `C#3.wav` - C Sharp (use # for sharps, not b for flats)
- `D3.wav`
- `D#3.wav`
- `E3.wav`
- `F3.wav`
- `F#3.wav`
- `G3.wav`
- `G#3.wav`
- `A3.wav`
- `A#3.wav`
- `B3.wav`
- And so on up to C5.wav

## Required Notes

You need audio files for all notes from **C3 to C5** (37 notes total):

**Octave 3:** C3, C#3, D3, D#3, E3, F3, F#3, G3, G#3, A3, A#3, B3
**Octave 4:** C4, C#4, D4, D#4, E4, F4, F#4, G4, G#4, A4, A#4, B4
**Octave 5:** C5, C#5, D5, D#5, E5, F5, F#5, G5, G#5, A5, A#5, B5

## Audio File Requirements

- **Format:** WAV (recommended) - MP3, OGG, and other formats also supported by just_audio
- **Duration:** 0.5-1 second per note (shorter is better for responsiveness)
- **Sample Rate:** 44100 Hz recommended
- **Bitrate:** 128-256 kbps
- **File Size:** Keep individual files under 100KB for performance

## How to Get Piano Sounds

### Option 1: AI/Online Tools
- Use online piano synthesizers like [piano.js](https://github.com/paulrosen/abcjs)
- Use AI tools to generate or convert piano samples
- Download from [freepd.com](https://freepd.com) or similar royalty-free music sites

### Option 2: Free Piano Libraries
- [Salamander Grand Piano](https://archive.org/details/SalamanderGrandPianoV3) - High-quality sample library
- [FluidR3_GM.sf2](https://www.freepats.zenvoid.org/) - General MIDI soundfont

### Option 3: Convert from MIDI
If you have a MIDI file, you can:
1. Open it in a DAW (like FL Studio, Ableton, Reaper, or free options like MuseScore)
2. Use a piano soundfont/VST
3. Export each note individually as a WAV file

### Option 4: Use MuseScore
1. Create a simple score with each note
2. Play it back and record/export as audio files
3. Use a tool like [Audacity](https://www.audacityteam.org/) to extract individual notes

### Option 5: Quick Online Solution
- Visit [Soundly](https://www.soundly.com/) or similar online piano tools
- Record each note and export as WAV

## Testing

Once you've added the audio files:
1. Run `flutter pub get` (if not done yet)
2. Run the app: `flutter run -d chrome` (or your device)
3. Open a validation task with the piano keyboard
4. Click keys - you should hear the corresponding piano notes

## Troubleshooting

### No sound plays:
1. Check that files are named correctly (case-sensitive on Linux):
   - Use `C3.wav`, `C#3.wav` (with #, not flat b)
   - Check for typos in note names
2. Verify files are in the correct `assets/sounds/piano/` directory
3. Check the pubspec.yaml has this directory configured under assets
4. Run `flutter clean` and `flutter pub get`
5. Rebuild: `flutter run -d chrome -v` for verbose output

### Files not being found:
- Make sure the asset path in pubspec.yaml includes `assets/sounds/piano/`
- Run `flutter pub get` after adding files

### Sound is choppy or delayed:
- Reduce file sizes (use bitrate 128kbps instead of higher)
- Use MP3 format instead of WAV (usually smaller file size)
- Pre-load audio in initialize() - already handled by the service

## Audio Format Support (via just_audio)

Supported on all platforms:
- WAV
- MP3
- OGG
- M4A/AAC
- FLAC

For best compatibility and web support, use **WAV** or **MP3**.

## Platform Support

The `just_audio` package provides cross-platform support:
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Windows
- ✅ Linux

