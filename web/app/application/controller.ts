// import { tracked } from '@glimmer/tracking';
import Controller from '@ember/controller';
// import { set } from '@ember/object';

// import { ALL_ASSISTANT_PARAMS } from '@unidancing/assistants';
// import { ALL_GAME_PARAMS } from '@unidancing/games';

// import type { Assistant } from '@unidancing/assistants';
// import type { Game } from '@unidancing/games';

// const PARAMS = [...ALL_GAME_PARAMS, ...ALL_ASSISTANT_PARAMS];

export default class ApplicationController extends Controller {
  // // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // // @ts-ignore
  // queryParams = ['game', 'assistant', ...PARAMS];
  // @tracked game?: Game;
  // @tracked assistant?: Assistant;
  // close = () => {
  //   this.game = undefined;
  //   for (const param of PARAMS) {
  //     // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  //     // @ts-ignore
  //     set(this, param, undefined);
  //   }
  // };
}
