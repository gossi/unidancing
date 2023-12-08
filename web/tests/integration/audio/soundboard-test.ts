import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { playSound } from '@unidancing/app/audio';
import sinon from 'sinon';

module('Integration | Audio | Soundboard', function (hooks) {
  setupTest(hooks);

  test('playSound', function (assert) {
    const audioService = this.owner.lookup('service:player');
    // const soundboard = audioService.soundboard;

    const play = sinon.stub(audioService.soundboard, 'play');

    playSound(this.owner)('surprise');
    assert.true(play.calledOnceWith('surprise'));
  });
});
