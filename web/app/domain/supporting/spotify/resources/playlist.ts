import { tracked } from '@glimmer/tracking';

import { service } from 'ember-polaris-service';
import { Resource, resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import { SpotifyService } from '../service';

import type { Playlist, Track } from '../domain-objects';
import type { ArgsWrapper } from 'ember-resources';

interface PlaylistArgs extends ArgsWrapper {
  named: {
    playlist: string;
  };
}

export class PlaylistResource extends Resource<PlaylistArgs> {
  @service(SpotifyService) declare spotify: SpotifyService;

  declare playlistId: string;

  @tracked playlist?: Playlist;

  get tracks(): Track[] | undefined {
    return this.playlist?.tracks?.items.map((tracks) => tracks.track as Track);
  }

  modify(_positional: PlaylistArgs['positional'], named: PlaylistArgs['named']): void {
    this.playlistId = named.playlist;

    this.load();
  }

  async load() {
    const response = await this.spotify.client.api.getPlaylist(this.playlistId);

    this.playlist = response;
  }
}

export const loadPlaylist = resourceFactory((playlist: string) => {
  return resource(async ({ owner }): Promise<Playlist> => {
    const { services } = sweetenOwner(owner);
    const { spotify } = services;

    const response = await spotify.client.api.getPlaylist(playlist);

    return response;
  });
});
