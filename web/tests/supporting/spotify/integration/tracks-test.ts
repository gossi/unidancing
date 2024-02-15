import { getContext } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { playTrack, SpotifyService } from '@unidancing/app/domain/supporting/spotify';
import { service } from 'ember-polaris-service';
import sinon from 'sinon';

import { RADIOACTIVE } from '../fixtures/tracks';

import type { TestContext } from '@ember/test-helpers';

module('Spotify | Integration | Tracks', function (hooks) {
  setupTest(hooks);

  test('playTrack', function (assert) {
    const context = getContext() as TestContext;

    const spotifyService = service(context, SpotifyService);
    const spotifyClient = spotifyService.client;
    const play = sinon.stub(spotifyClient.api, 'play');

    playTrack(context.owner)(RADIOACTIVE);
    assert.true(
      play.calledOnceWith({
        uris: [RADIOACTIVE.uri]
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
