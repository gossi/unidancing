/* eslint-disable @typescript-eslint/naming-convention */
export type Playlist = SpotifyApi.SinglePlaylistResponse | SpotifyApi.PlaylistObjectSimplified;
export type Device = SpotifyApi.UserDevice;
export type Artist = SpotifyApi.ArtistObjectSimplified | SpotifyApi.ArtistObjectFull;
export type Album = (SpotifyApi.AlbumObjectSimplified | SpotifyApi.AlbumObjectFull) & {
  artists?: Artist[];
  total_tracks?: number;
};

export type Track = (SpotifyApi.TrackObjectSimplified | SpotifyApi.TrackObjectFull) & {
  album: Album;
  is_local?: boolean;
};
