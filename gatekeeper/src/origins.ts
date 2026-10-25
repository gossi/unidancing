function matchHostPort(candidate: URL, hostPort: string): boolean {
  if (!hostPort) {
    return false;
  }

  const colon = hostPort.lastIndexOf(':');
  const host = colon === -1 ? hostPort : hostPort.slice(0, colon);
  const port = colon === -1 ? '' : hostPort.slice(colon + 1);

  // `URL#port` is '' for default ports; patterns omit them likewise
  if (port !== '*' && port !== candidate.port) {
    return false;
  }

  if (host.startsWith('*.')) {
    const suffix = host.slice(1); // keep the leading '.'

    if (!candidate.hostname.endsWith(suffix)) {
      return false;
    }

    const label = candidate.hostname.slice(0, -suffix.length);

    return label !== '' && !label.includes('.');
  }

  return candidate.hostname === host;
}

/**
 * Origin allowlist matching for the login callback relay. The `state`
 * envelope carries the frontend origin to relay to; this guard is what keeps
 * the relay from becoming an open redirect.
 *
 * The allowlist is a comma-separated list of `scheme://host[:port]` patterns:
 * - the first host label may be `*`, matching exactly one label
 *   (`https://*.unidancing.pages.dev` for Cloudflare Pages branch previews)
 * - the port may be `*` (`http://localhost:*` for local dev)
 */
function matchOrigin(origin: string, allowList: string | undefined): boolean {
  if (!allowList) {
    return false;
  }

  let candidate: URL;

  try {
    candidate = new URL(origin);
  } catch {
    return false;
  }

  const protocol = candidate.protocol.replace(':', '');

  return allowList
    .split(',')
    .map((pattern) => pattern.trim().toLowerCase())
    .filter((pattern) => pattern.includes('://'))
    .some((pattern) => {
      const schemeEnd = pattern.indexOf('://');

      if (pattern.slice(0, schemeEnd) !== protocol) {
        return false;
      }

      // drop any path/query noise; origins shouldn't have any, but be strict
      const hostPort = pattern.slice(schemeEnd + 3).split('/', 1)[0];

      return matchHostPort(candidate, hostPort);
    });
}

export { matchOrigin };
