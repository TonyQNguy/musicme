import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicme/models/song.dart';

class PlaylistProvider extends ChangeNotifier { 

  final List<Song> _playlist = [ 
    // song 1
    Song(
      songName: "Heebiejeebies", 
      artistName: "Amine", 
      albumCoverImagePath: "assets/covers/amine.jpg", 
      audioPath: "songs/Heebiejeebies (Bonus).mp3"
      
    ),
    // song 2
    Song(
      songName: "Stuck In a Dream", 
      artistName: "Lil Mosey", 
      albumCoverImagePath: "assets/covers/lilmosey.jpg", 
      audioPath: "songs/Lil Mosey - Stuck In A Dream (Lyrics) ft. Gunna.mp3"
    ),
    // song 3
    Song(
      songName: "See Through", 
      artistName: "The Band CAMINO", 
      albumCoverImagePath: "assets/covers/camino.jpg", 
      audioPath: "songs/See Through.mp3"
    ),
  ];


  // current song playing index
  int? _currentSongIndex;


  /*
    A U D I O
  */
  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // inital not playing
  bool _isPlaying = false;

  // play song
  void play() async { 
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop the current song
    await _audioPlayer.play(AssetSource(path)); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause song
  void pause() async { 
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume song
  void resume() async { 
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async { 
    if (_isPlaying) { 
      pause();
    } else { 
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the song
  void seek(Duration position) async { 
    await _audioPlayer.seek(position);
  }

  // play next
  void playNextSong() async { 
    if (_currentSongIndex != null) { 
      if (_currentSongIndex! < _playlist.length - 1) { 
        // go to next song if it's not the last one
        _currentSongIndex = _currentSongIndex! + 1;
      } else { 
        // if it is last song then go to first
        currentSongIndex = 0;
      }
    }
  }

  // play previous
  void playPrevSong() async { 
    // if more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) { 
      seek(Duration.zero);
    } else { 
      if (_currentSongIndex! > 0) { 
        currentSongIndex = _currentSongIndex! - 1;
      } else { 
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() { 
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) { 
      _totalDuration = newDuration;
      notifyListeners();
    }); 

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition){ 
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) { 
      playNextSong();
    });
  }
  // dispose audio player

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
  set currentSongIndex(int? newIndex) { 
    _currentSongIndex = newIndex;

    if (newIndex != null) { 
      play();
    }

    // updates the UI
    notifyListeners();
  }
  /*
    Setters 
  */
}