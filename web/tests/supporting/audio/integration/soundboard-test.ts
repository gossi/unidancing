import { service } from 'ember-polaris-service';
import { test } from 'ember-vitest';
import sinon from 'sinon';
import { describe, expect } from 'vitest';

import { AudioService, playSound } from '#support/audio';

describe('Audio | Integration | Soundboard', () => {
  // deep imports skip the barrel's component graph; `context` is the extended
  // ember-vitest fixture (TestContext with setOwner — same object the qunit
  // setupTest provided)
  test('playSound', async ({ context }) => {
    const audioService = service(context, AudioService);

    const play = sinon.stub(audioService.soundboard, 'play');

    await playSound(context.owner)('surprise');
    expect(play.calledOnceWith('surprise')).toBe(true);
  });
});
