import Case from 'case';

export function deserialize(object: Record<string, unknown>): Record<string, unknown> {
  const out: Record<string, unknown> = {};

  for (const [key, value] of Object.entries(object)) {
    out[Case.camel(key)] =
      typeof value === 'object' ? deserialize(value as Record<string, unknown>) : value;
  }

  return out;
}
