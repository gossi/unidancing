import Route from '@ember/routing/route';

export default class MoveDetailsRoute extends Route {
  model(params: { id: string }) {
    return params;
  }
}
