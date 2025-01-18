import { getContext } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { playTrack, SpotifyService } from '@unidancing/app/domain/supporting/spotify';
import { service } from 'ember-polaris-service';
import sinon from 'sinon';

import { RADIOACTIVE } from '../fixtures/tracks';

import type { TestContext } from '@ember/test-helpers';

module('Spotify | Integration | Tracks', function (hooks) {
  setupTest(hooks);

  test('playTrack', async (assert) => {
    const context = getContext() as TestContext;

    const spotifyService = service(context, SpotifyService);
    const spotifyClient = spotifyService.client;
    const play = sinon.stub(spotifyClient, 'play');

    await playTrack(context.owner)(RADIOACTIVE);

    assert.true(
      play.calledOnceWith({
        uris: [RADIOACTIVE.uri],
        // eslint-disable-next-line @typescript-eslint/naming-convention
        position_ms: 0
      })
    );
  });

  // this is called with random

  // tst('playTrackForDancing', function (assert) {
  //   const spotifyService = this.owner.lookup('service:spotify');
  //   const spotifyClient = spotifyService.client;
  //   const play = sinon.stub(spotifyClient.api, 'play');

  //   playTrackForDancing(this.owner)(RADIOACTIVE, 30);
  //   assert.true(
  //     play.calledOnceWith({
  //       uris: [RADIOACTIVE.uri]
  //     })
  //   );
  // });
});
