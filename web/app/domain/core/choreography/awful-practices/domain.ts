import type { Maybe } from '@/tina/types';
export type { Awfulpractice } from '@/tina/types';
export enum Tag {
  Choreo = 'choreography',
  Artistry = 'artistry',
  Tricks = 'tricks',
  Flow = 'flow',
  Posture = 'posture',
  Competition = 'competition',
  Misc = 'misc'
}
export const TAGS = [...Object.values(Tag)];

export function asTag(tag: Maybe<string>): Tag {
  return tag as Tag;
}
