import { assert } from '@ember/debug';
import { setOwner } from '@ember/application';
import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export interface Player {
  toggle(): Promise<void> | void;
}

export function lookupPlayer(klass: object, owner: unknown) {
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  const player = klass.getInstance();

  assert(`Player "${klass}" not found!`, player !== undefined);
  setOwner(player, owner);
  return player;
}

export class PlayerService extends Service implements Player {
  @tracked player?: Player;

  toggle() {
    this.player?.toggle();
  }
}

declare module '@ember/service' {
  interface Registry {
    player: PlayerService;
  }
}
