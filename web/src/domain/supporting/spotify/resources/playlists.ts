import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';
import { trackedFunction } from 'reactiveweb/function';

import { SpotifyService } from '../service';

import type { UserPlaylist } from '../domain-objects';

// https://open.spotify.com/playlist/3qaxO2Z99batsuhi12MDsn?si=865135aca7b64c32

export const loadPlaylists = resourceFactory(() => {
  return resource(({ owner, use }): (() => UserPlaylist[]) => {
    const { service } = sweetenOwner(owner);
    const spotify = service(SpotifyService);

    const request = use(
      trackedFunction(async () => {
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        const response = await spotify.client.api.getUserPlaylists({
          limit: 50
        });

        return response.items;
      })
    );

    return () => request.current.value as unknown as UserPlaylist[];
  });
});
