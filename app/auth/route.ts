import Transition from '@ember/routing/-private/transition';
import Route from '@ember/routing/route';
import RouterService from '@ember/routing/router-service';
import { service } from '@ember/service';
import SpotifyService from '../services/spotify';

export default class AuthRoute extends Route {
  @service declare spotify: SpotifyService;
  @service declare router: RouterService;

  beforeModel(transition: Transition) {
    const { token } = transition.to.queryParams;

    if (token) {
      this.spotify.grant(token);
    }

    this.router.transitionTo('application');
  }
}
