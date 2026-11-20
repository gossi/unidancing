// deep imports skip the index barrel's component graph (the components +
// auth route pull decorators that the vitest transform cannot apply)
import { service } from 'ember-polaris-service';
import { test } from 'ember-vitest';
import sinon from 'sinon';
import { describe, expect } from 'vitest';

import { SpotifyService } from '../../../../src/support/spotify/service';
import { playTrack } from '../../../../src/support/spotify/tracks';
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
