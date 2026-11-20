/**
 * PKCE helpers for the Spotify login flow (RFC 7636).
 *
 * The code verifier is generated and kept in this browser tab: Spotify
 * redirects the authorization `code` back through the worker, which then
 * presents the stored verifier (alongside the code) for the token exchange.
 * Only the derived S256 challenge leaves the client before that exchange.
 *
 * The `state` is a routing + CSRF envelope, base64url of `{ n, o }`:
 * - `n` — a single-use nonce only this tab knows; compared verbatim when the
 *   callback returns, so a delivered `code` is proven to originate from a
 *   login *this* session started (login-CSRF guard).
 * - `o` — this tab's origin, which the worker validates against its
 *   allowlist and relays the callback to. That lets one registered Spotify
 *   redirect URI (the worker's own) serve dev, preview and prod FE origins.
 */

const STORAGE_KEY = 'spotify.auth.attempt';

interface AuthAttempt {
  codeVerifier: string;
  /** The exact `state` envelope sent to Spotify (nonce + origin). */
  state: string;
  /** App-relative URL (path + query) to continue with after a successful login. */
  returnTo?: string;
}

function randomHex(bytes: number): string {
  const values = new Uint8Array(bytes);

  crypto.getRandomValues(values);

  return Array.from(values, (value) => value.toString(16).padStart(2, '0')).join('');
}

/** 64 characters from the RFC 7636 unreserved set, 256 bits of entropy. */
function createCodeVerifier(): string {
  return randomHex(32);
}

function toBase64Url(bytes: Uint8Array): string {
  const base64 = btoa(String.fromCodePoint(...bytes));

  return base64.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
}

async function createCodeChallenge(codeVerifier: string): Promise<string> {
  const encoder = new TextEncoder();
  const digest = await crypto.subtle.digest('SHA-256', encoder.encode(codeVerifier));

  return toBase64Url(new Uint8Array(digest));
}

/**
 * The callback envelope the worker decodes for routing and the FE compares
 * verbatim on return. Keep the key order stable — the deterministic encoding
 * is what makes the string-equality CSRF check work.
 */
function createAuthState(): string {
  const encoder = new TextEncoder();
  const envelope = JSON.stringify({ n: randomHex(16), o: globalThis.location.origin });

  return toBase64Url(encoder.encode(envelope));
}

function saveAuthAttempt(attempt: AuthAttempt): void {
  sessionStorage.setItem(STORAGE_KEY, JSON.stringify(attempt));
}

function loadAuthAttempt(): AuthAttempt | undefined {
  const stored = sessionStorage.getItem(STORAGE_KEY);

  if (!stored) {
    return undefined;
  }

  try {
    return JSON.parse(stored) as AuthAttempt;
  } catch {
    return undefined;
  }
}

function clearAuthAttempt(): void {
  sessionStorage.removeItem(STORAGE_KEY);
}

export {
  clearAuthAttempt,
  createAuthState,
  createCodeChallenge,
  createCodeVerifier,
  loadAuthAttempt,
  saveAuthAttempt
};

export type { AuthAttempt };
