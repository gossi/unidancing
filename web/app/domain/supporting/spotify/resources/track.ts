import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';
import { trackedFunction } from 'reactiveweb/function';

import { SpotifyService } from '../service';

import type { Track } from '../domain-objects';

export const findTrack = resourceFactory((track: string | (() => string)) => {
  return resource(({ owner, use }): (() => Track) => {
    const { service } = sweetenOwner(owner);
    const spotify = service(SpotifyService);

    const request = use(
      trackedFunction(async () => {
        const trackId = typeof track === 'function' ? track() : track;

        return await spotify.client.api.getTrack(trackId);
      })
    );

    return () => request.current.value as unknown as Track;
  });
});
