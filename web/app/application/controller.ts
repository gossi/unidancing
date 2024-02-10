import { tracked } from '@glimmer/tracking';
import Controller from '@ember/controller';
import { set } from '@ember/object';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { ALL_ASSISTANT_PARAMS } from '../domain/core/assistants';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { ALL_GAME_PARAMS } from '../domain/core/games';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import type { Assistant } from '../domain/core/assistants';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import type { Game } from '../domain/core/games';

const PARAMS = [...ALL_GAME_PARAMS, ...ALL_ASSISTANT_PARAMS];

export default class ApplicationController extends Controller {
  // // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // // @ts-ignore
  queryParams = ['game', 'assistant', ...PARAMS];
  @tracked game?: Game;
  @tracked assistant?: Assistant;
  close = () => {
    this.game = undefined;
    this.assistant = undefined;

    for (const param of PARAMS) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      set(this, param, undefined);
    }
  };
}
