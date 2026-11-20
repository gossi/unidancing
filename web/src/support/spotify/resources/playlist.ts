import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';
import { trackedFunction } from 'reactiveweb/function';

import { SpotifyService } from '../service';

import type { Playlist, Track } from '../domain-objects';

export function getTracks(playlist: Playlist): Track[] {
  return playlist.tracks.items.map((tracks) => tracks.track as Track);
}

export const loadPlaylist = resourceFactory(
  (playlist: string | Playlist | (() => string | Playlist)) => {
    return resource(({ owner, use }): (() => Playlist) => {
      const { service } = sweetenOwner(owner);
      const spotify = service(SpotifyService);

      const request = use(
        trackedFunction(async () => {
          const idOrPlaylist = typeof playlist === 'function' ? playlist() : playlist;

          if (typeof idOrPlaylist === 'string') {
            return await spotify.client.api.getPlaylist(idOrPlaylist);
          }

          return idOrPlaylist;
        })
      );

      return () => request.current.value as unknown as Playlist;
    });
  }
);
