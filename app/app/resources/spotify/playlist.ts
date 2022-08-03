import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import SpotifyService from '../../services/spotify';
import { ArgsWrapper, Resource } from 'ember-resources';

// https://open.spotify.com/playlist/3qaxO2Z99batsuhi12MDsn?si=865135aca7b64c32

interface PlaylistArgs extends ArgsWrapper {
  named: {
    playlist: string;
  };
}

function randomItem<T>(items: T[]) {
  return items[Math.floor(Math.random() * items.length)];
}

export function getRandomTracks(
  list: SpotifyApi.TrackObjectFull[],
  amount = 5
): SpotifyApi.TrackObjectFull[] {
  const tracks: SpotifyApi.TrackObjectFull[] = [];
  while (tracks.length < amount) {
    const track = randomItem<SpotifyApi.TrackObjectFull>(list);

    if (!tracks.includes(track)) {
      tracks.push(track);
    }
  }

  return tracks;
}

export class PlaylistResource extends Resource<PlaylistArgs> {
  @service declare spotify: SpotifyService;

  @tracked playlist?: SpotifyApi.SinglePlaylistResponse;

  get tracks(): SpotifyApi.TrackObjectFull[] | undefined {
    return this.playlist?.tracks?.items.map(
      (tracks) => tracks.track as SpotifyApi.TrackObjectFull
    );
  }

  modify(
    _positional: PlaylistArgs['positional'],
    named: PlaylistArgs['named']
  ): void {
    console.log(named);

    // this.load(named.playlist);
  }

  private async load(playlist: string) {
    const response = await this.spotify.client.getPlaylist(playlist);

    console.log(response);

    this.playlist = response;
  }
}

export function usePlaylist(destroyable: object, args: PlaylistArgs['named']) {
  console.log('args', args);

  return PlaylistResource.from(destroyable, () => {
    console.log('from', args);
    return {
      playlist: (() => args.playlist)()
    };
  });
}
