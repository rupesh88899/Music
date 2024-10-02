import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:music/models/song.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter_media_metadata/flutter_media_metadata.dart'; // Import metadata package

class PlaylistProvider extends ChangeNotifier {
  //playlist of songs
  // List to store songs dynamically fetched from the device
  final List<Song> _playlist = [];

// List of album art images
  final List<String> albumArtImages = [
    'assets/images/album_art_1.png',
    'assets/images/album_art_2.png',
    'assets/images/album_art_3.png',
    'assets/images/album_art_4.png',
    'assets/images/album_art_5.png',
    'assets/images/album_art_6.png',
    'assets/images/album_art_7.png',
    'assets/images/album_art_8.png',
    'assets/images/album_art_9.png',
    'assets/images/album_art_10.png',
    'assets/images/album_art_11.png',
    'assets/images/album_art_12.png',
    'assets/images/album_art_13.png',
  ];

  // helper function to format the name of the song
  String formatFileName(String filePath, {int maxLength = 20}) {
    // Get the last part of the file path
    String fileName = filePath.split('/').last;

    // Check if the length exceeds maxLength
    if (fileName.length > maxLength) {
      return '${fileName.substring(0, maxLength - 3)}...'; // Append ellipses
    }
    return fileName; // Return the original name if it's within the limit
  }

  /* 
  
  A U D I O P L A Y E R
  
  */

  //curremt song is playing index
  int? _currentSongIndex; // using this we can change the current song
  //duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  //audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  //initially not playing
  bool _isPlaying = false;

  //constructor
  PlaylistProvider() {
    _currentSongIndex = 0; // Start with the first song
    listenToDuration();
    _loadSongsFromMusicFolder(); // Load songs from the folder on initialization
  }

  // Method to load songs from a specific folder (Music folder in this case)
  Future<void> _loadSongsFromMusicFolder() async {
    // Request storage permission
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      // Access the Music directory on the device
      Directory musicDir =
          Directory('/storage/emulated/0/Music'); // Android Music folder path

      if (await musicDir.exists()) {
        // List all files in the directory
        List<FileSystemEntity> files = musicDir.listSync();

        // Iterate through the files and add .mp3 files to the playlist
        for (var file in files) {
          if (file.path.endsWith('.mp3')) {
            _addSongFromFileSystem(file.path);
          }
        }
      } else {
        print("Music directory does not exist.");
      }
    } else {
      print("Storage permission denied.");
    }
  }

  // Helper function to add a song from file system to the playlist
  Future<void> _addSongFromFileSystem(String filePath) async {
    try {
      // final metadata = await MetadataRetriever.fromFile(File(filePath));

      // Determine the index for the album art based on the current number of songs
      int albumArtIndex = _playlist.length %
          albumArtImages.length; // Use modulus to cycle through 4 images

      // Use metadata if available, fallback to defaults if not
      Song newSong = Song(
        songName: formatFileName(filePath), // Use track name or file name
        songArtist: '', // Use artist name or default
        albumArtImagePath:
            albumArtImages[albumArtIndex], // Default album art if none
        songPath: filePath,
      );

      _playlist.add(newSong);
      notifyListeners();
    } catch (e) {
      print('Error extracting metadata: $e');
    }
  }
  // Audio control methods

  //play song
  void play() async {
    if (_currentSongIndex != null && _playlist.isNotEmpty) {
      String path = _playlist[_currentSongIndex!].songPath;
      await _audioPlayer.stop(); // Stop any current song
      await _audioPlayer
          .play(DeviceFileSource(path)); // Play the new song from file system
      _isPlaying = true;
      notifyListeners();
    }
  }

  //pause song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  //resume song
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  ///pause and resume
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  ///seek toa specific psition in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        //go to next song if it is not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        //if it is last song play first song , loop back to first song
        currentSongIndex = 0;
      }
    }
  }

  //play previous song
  void playPreviousSong() async {
    //if more then 2 sec has passed ,restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        //if it's the first song .loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //list to duration

  void listenToDuration() {
    //listen for totle duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose audio player

  /* 
  
  G E T T E R S
  
  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  /* 
  
  S E T T E R S
  
  */

  // Setter for changing the current song index
  set currentSongIndex(int? newIndex) {
    //update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      //notify listeners
      play();
    }
    notifyListeners();
  }
}
