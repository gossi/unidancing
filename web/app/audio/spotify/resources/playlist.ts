import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';

import { Resource } from 'ember-resources';

import type { Playlist } from '../domain-objects';
import type SpotifyService from '../service';
import type { ArgsWrapper } from 'ember-resources';

// https://open.spotify.com/playlist/3qaxO2Z99batsuhi12MDsn?si=865135aca7b64c32

interface PlaylistArgs extends ArgsWrapper {
  named: {
    playlist: string;
  };
}

export class PlaylistResource extends Resource<PlaylistArgs> {
  @service declare spotify: SpotifyService;

  @tracked playlist?: Playlist;

  get tracks(): SpotifyApi.TrackObjectFull[] | undefined {
    return this.playlist?.tracks?.items.map((tracks) => tracks.track as SpotifyApi.TrackObjectFull);
  }

  modify(_positional: PlaylistArgs['positional'], named: PlaylistArgs['named']): void {
    this.load(named.playlist);
  }

  private async load(playlist: string) {
    const response = await this.spotify.client.api.getPlaylist(playlist);

    this.playlist = response;
  }
}
