export function ensureArray<T>(stringOrArray?: T | T[]): T[] {
  return stringOrArray
    ? Array.isArray(stringOrArray)
      ? stringOrArray
      : [stringOrArray]
    : [];
}
