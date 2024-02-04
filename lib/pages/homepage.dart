import 'package:flutter/material.dart';
import 'package:musicme/components/mydrawer.dart';
import 'package:musicme/models/playlist_provider.dart';
import 'package:musicme/models/song.dart';
import 'package:musicme/pages/songpage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget { 
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final dynamic playlistProvider;

  @override
  void initState() { 
    super.initState();

    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) { 

    playlistProvider.currentSongIndex = songIndex;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SongPage(), )
    );
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("P L A Y L I S T"), backgroundColor: Theme.of(context).colorScheme.primary, ),
      drawer: const MyDrawer(),
      body: Consumer<PlaylistProvider>(
        builder: (context, value, child) { 
          final List<Song> playlist = value.playlist;

          return ListView.builder(
            itemCount: playlist.length,
            itemBuilder: (context, index) { 
              // get song
              final Song song = playlist[index];

              return ListTile(
                title: Text(song.songName),
                subtitle: Text(song.artistName),
                leading: Image.asset(song.albumCoverImagePath),
                onTap: () => goToSong(index),
              );
            }
          );
        }
      )
    );
  }

}