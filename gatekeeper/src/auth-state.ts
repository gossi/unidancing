/**
 * Decoding side of the `state` envelope built by the frontend
 * (`web/app/domain/supporting/spotify/pkce.ts`): base64url of
 * `{ n: nonce, o: origin }`.
 *
 * The worker never interprets `n` — it belongs to the frontend's CSRF check
 * and is echoed back untouched. `o` is the callback relay target, and is only
 * trusted after validation against the configured allowlist.
 */

interface AuthState {
  n: string;
  o: string;
}

function fromBase64Url(value: string): string {
  const base64 = value.replaceAll('-', '+').replaceAll('_', '/');

  return atob(base64.padEnd(Math.ceil(base64.length / 4) * 4, '='));
}

function decodeAuthState(value: string | undefined): AuthState | undefined {
  if (!value) {
    return undefined;
  }

  try {
    const state = JSON.parse(fromBase64Url(value)) as Partial<AuthState>;

    if (typeof state.n === 'string' && typeof state.o === 'string') {
      return { n: state.n, o: state.o };
    }
  } catch {
    // malformed state — treated as absent by the caller
  }

  return undefined;
}

export { decodeAuthState };
