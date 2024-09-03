import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

actor {
  type Song = {
    id: Nat;
    title: Text;
    artist: Text;
    duration: Nat; // Duration in seconds
  };

  type Playlist = {
    id: Nat;
    name: Text;
    songs: Buffer.Buffer<Song>;
  };

  var songs = Buffer.Buffer<Song>(0);
  var playlists = Buffer.Buffer<Playlist>(0);

  public func addSong(title: Text, artist: Text, duration: Nat) : async Nat {
    let id = songs.size();
    let newSong: Song = {
      id;
      title;
      artist;
      duration;
    };
    songs.add(newSong);
    id
  };

  public func createPlaylist(name: Text) : async Nat {
    let id = playlists.size();
    let newPlaylist: Playlist = {
      id;
      name;
      songs = Buffer.Buffer<Song>(0);
    };
    playlists.add(newPlaylist);
    id
  };

  public func addSongToPlaylist(playlistId: Nat, songId: Nat) : async Bool {
    if (playlistId >= playlists.size() or songId >= songs.size()) return false;
    let playlist = playlists.get(playlistId);
    let song = songs.get(songId);
    playlist.songs.add(song);
    true
  };

  public query func getPlaylist(id: Nat) : async ?{id: Nat; name: Text; songs: [Song]} {
  if (id >= playlists.size()) return null;
  let playlist = playlists.get(id);
  ?{
    id = playlist.id;
    name = playlist.name;
    songs = Buffer.toArray(playlist.songs);
  }
  };

  public query func getPlaylistDuration(id: Nat) : async ?Nat {
    if (id >= playlists.size()) return null;
    let playlist = playlists.get(id);
    var totalDuration = 0;
    for (song in playlist.songs.vals()) {
      totalDuration += song.duration;
    };
    ?totalDuration
  };
}