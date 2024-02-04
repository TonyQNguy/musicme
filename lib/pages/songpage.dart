import 'package:flutter/material.dart';
import 'package:musicme/components/neu_box.dart';
import 'package:musicme/models/playlist_provider.dart';
import 'package:musicme/pages/homepage.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  // convert duration into truncated float
  String formatTime(Duration duration) { 
    String twoDigitSeconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    String formattedTime = "${duration.inMinutes}:${twoDigitSeconds}";

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) { 
        

        // get playlist
        final playlist = value.playlist;

        // get current song index
        final currentSong = playlist[value.currentSongIndex ?? 0];

        // return Scaffold UI 
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  // app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back button
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                  
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(),
                            )
                          );
                        },
                        icon: const Icon(Icons.arrow_back)
                      ),

                      // title
                      const Text("S O N G S"),

                      // menu
                      IconButton(
                        onPressed: () {}, 
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),

                  // album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect( 
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(currentSong.albumCoverImagePath),
                        ),

                        Padding( 
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // song and artist name
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentSong.songName, 
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 20,
                                    )
                                  ),
                                  Text(
                                    currentSong.artistName,
                                  ),
                                ],
                              ),

                              // like icon
                              const Icon( 
                                Icons.favorite,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // song duration progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // start time
                            Text(formatTime(value.currentDuration)),
                        
                            // shuffle
                            const Icon(Icons.shuffle),
                            
                            // repeat
                            const Icon(Icons.repeat),
                        
                            // end
                            Text(formatTime(value.totalDuration)),
                          ]
                        ),
                      ),

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith( 
                          thumbShape: 
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                        ), 
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Colors.green,
                          onChanged: (double double) {
                            // during when the user is sliding around

                          },
                          onChangeEnd: (double double) { 
                            // sliding has finished go to that position in song
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // playback controls 
                  Row(
                    children: [
                      // skip previous
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPrevSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous)
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      //play pause
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.pauseOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying ? Icons.pause: Icons.play_arrow),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // skip foward
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNextSong,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next)
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}