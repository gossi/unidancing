import Route from '@ember/routing/route';

export default class ExerciseDetailsRoute extends Route {
  model(params: { id: string }) {
    return params;
  }
}
