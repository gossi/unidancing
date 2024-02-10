import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { playTrack } from '@unidancing/app/domain/supporting/spotify';
import sinon from 'sinon';

import { RADIOACTIVE } from '../../../fixtures/spotify/tracks';

module('Integration | Audio | Spotify | Tracks', function (hooks) {
  setupTest(hooks);

  test('playTrack', function (assert) {
    const spotifyService = this.owner.lookup('service:spotify');
    const spotifyClient = spotifyService.client;
    const play = sinon.stub(spotifyClient.api, 'play');

    playTrack(this.owner)(RADIOACTIVE);
    assert.true(
      play.calledOnceWith({
        uris: [RADIOACTIVE.uri]
      })
    );
  });

  // this is called with random

  // test('playTrackForDancing', function (assert) {
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
