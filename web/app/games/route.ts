import Route from '@ember/routing/route';

import type { Game } from './games';

export default class ExerciseDetailsRoute extends Route {
  model({ id }: { id: Game }) {
    return {
      id
    };
  }
}
