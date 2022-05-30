import { assert } from '@ember/debug';
import { setOwner } from '@ember/application';

export interface Player {
  toggle(): Promise<void> | void;
}

export function lookupPlayer(klass: object, owner: unknown) {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  const player = klass.getInstance();

  assert(`Player "${name}" not found!`, player !== undefined);
  setOwner(player, owner);
  return player;
}
