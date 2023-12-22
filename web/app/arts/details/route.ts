import Route from '@ember/routing/route';

export default class ArtDetailsRoute extends Route {
  model(params: { id: string }) {
    return params;
  }
}
