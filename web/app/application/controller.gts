import { tracked } from '@glimmer/tracking';
import { set } from '@ember/object';
import Controller from '@ember/controller';

import { ALL_ASSISTANT_PARAMS } from '../domain/core/assistants';
import { ALL_GAME_PARAMS } from '../domain/core/games';

import type { Assistant } from '../domain/core/assistants';
import type { Game } from '../domain/core/games';

const PARAMS = [...ALL_GAME_PARAMS, ...ALL_ASSISTANT_PARAMS];

export default class ApplicationController extends Controller {
  queryParams = ['game', 'assistant', ...PARAMS];

  @tracked game?: Game;
  @tracked assistant?: Assistant;

  close = () => {
    this.game = undefined;
    this.assistant = undefined;

    for (const param of PARAMS) {
      set(this, param, undefined);
    }
  };
}
