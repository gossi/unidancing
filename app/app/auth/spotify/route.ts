import Transition from '@ember/routing/-private/transition';
import Route from '@ember/routing/route';
import RouterService from '@ember/routing/router-service';
import { service } from '@ember/service';
import SpotifyService from '../../services/spotify';
import { deserialize } from '../../utils/serde';

export default class SpotifyAuthRoute extends Route {
  @service declare spotify: SpotifyService;
  @service declare router: RouterService;

  beforeModel(transition: Transition) {
    if (Object.keys(transition.to.queryParams).length > 0) {
      this.spotify.auth(deserialize(transition.to.queryParams));

      const redirectAfterLogin = localStorage.getItem('redirectAfterLogin');

      if (redirectAfterLogin) {
        localStorage.removeItem('redirectAfterLogin');
        this.router.transitionTo(redirectAfterLogin);
      } else {
        this.router.transitionTo('application');
      }
    }
  }
}
