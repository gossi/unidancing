import { getContext } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { AudioService, playSound } from '@unidancing/app/domain/supporting/audio';
import { service } from 'ember-polaris-service';
import sinon from 'sinon';

import type { TestContext } from '@ember/test-helpers';

module('Audio | Integration | Soundboard', function (hooks) {
  setupTest(hooks);

  test('playSound', async (assert) => {
    const context = getContext() as TestContext;

    const audioService = service(context, AudioService);

    const play = sinon.stub(audioService.soundboard, 'play');

    await playSound(context.owner)('surprise');
    assert.true(play.calledOnceWith('surprise'));
  });
});
