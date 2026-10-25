import { SpotifyClient } from '@unidancing/app/domain/supporting/spotify/client';
import sinon from 'sinon';
import { describe, expect, test } from 'vitest';

// the interpreter chains transitions through promise microtasks; a few
// macrotask ticks drain them all
const tick = async () => {
  await new Promise((resolve) => globalThis.setTimeout(resolve, 0));
};

describe('Spotify | Unit | Client | machine wiring', () => {
  // Regression: the `statechart` field's setup callback runs while the class
  // is still initializing (before the service methods exist), so the machine
  // services must resolve `this.*` lazily. Eagerly destructured, invoking
  // `connectPlayer` threw "connectPlayer is not a function" right after auth
  // and `loadDevices.perform()` on undefined — see errors.md.
  test('authenticate invokes services through the live instance', async () => {
    const client = new SpotifyClient();

    sinon.stub(client.api, 'getMe').resolves({ id: 'tester' } as never);

    const connectPlayer = sinon.stub(client, 'connectPlayer').resolves();
    const getPlaybackState = sinon.stub(client.player, 'getPlaybackState').resolves(undefined);

    expect(await client.authenticate('token')).toBe(true);

    expect(client.authenticated).toBe(true);
    expect(connectPlayer.calledOnceWith('token')).toBe(true);
    expect(getPlaybackState.called).toBe(true);
  });

  // Regression: `ready` matched `{ authenticated: 'ready' }`, but
  // `authenticated` is a parallel state ({ device, playback } regions), so the
  // flat path could never match — Dance Mix kept showing "select player" even
  // after the web player was connected and selected.
  test('a selected device marks the client ready for playback', async () => {
    const client = new SpotifyClient();

    sinon.stub(client.api, 'getMe').resolves({ id: 'tester' } as never);
    sinon.stub(client.player, 'getPlaybackState').resolves(undefined);

    const transfer = sinon.stub(client.api, 'transferMyPlayback').resolves({});

    // the SDK connection only counts as successful once the player reports
    // ready — the machine's `hasDevices` guard keys off exactly that
    sinon.stub(client, 'connectPlayer').callsFake(() => {
      (client.player as unknown as { _ready?: boolean })._ready = true;

      return Promise.resolve();
    });

    expect(await client.authenticate('token')).toBe(true);

    expect(client.ready).toBe(false);

    await tick();
    await tick();
    await tick();

    expect(client.ready).toBe(true);
    expect(transfer.calledOnce).toBe(true);
  });
});
