// deep imports skip the index.gts barrel's component graph
import { SpotifyService } from '@unidancing/app/domain/supporting/spotify/service';
import { playTrack } from '@unidancing/app/domain/supporting/spotify/tracks';
import { service } from 'ember-polaris-service';
import { test } from 'ember-vitest';
import sinon from 'sinon';
import { describe, expect } from 'vitest';

import { RADIOACTIVE } from '../fixtures/tracks';

describe('Spotify | Integration | Tracks', () => {
  // `context` is the extended ember-vitest fixture (TestContext with
  // setOwner — same object shape the qunit setupTest provided)
  test('playTrack', async ({ context }) => {
    const spotifyService = service(context, SpotifyService);
    const spotifyClient = spotifyService.client;
    const play = sinon.stub(spotifyClient, 'play');

    await playTrack(context.owner)(RADIOACTIVE);

    expect(
      play.calledOnceWith({
        uris: [RADIOACTIVE.uri],

        position_ms: 0
      })
    ).toBe(true);
  });
});
