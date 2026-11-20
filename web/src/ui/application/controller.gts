import { tracked } from '@glimmer/tracking';
import Controller from '@ember/controller';
import { set } from '@ember/object';

import { ALL_ASSISTANT_PARAMS } from '#assistants';
import { ALL_GAME_PARAMS } from '#games';

import type { Assistant } from '#assistants';
import type { Game } from '#games';

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
