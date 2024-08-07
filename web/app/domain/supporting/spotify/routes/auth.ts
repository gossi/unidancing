import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { service as polarisService } from 'ember-polaris-service';

import { deserialize, isSSR } from '../../utils';
import { SpotifyService } from '../service';

import type RouteInfo from '@ember/routing/route-info';
import type RouterService from '@ember/routing/router-service';
import type Transition from '@ember/routing/transition';

type RouteModel = object | string | number;
type RouteArgs = Parameters<RouterService['urlFor']>;

function makeRouteArgs({
  name,
  models,
  query
}: {
  name: string;
  models: RouteModel[];
  query?: Record<string, unknown>;
}): RouteArgs {
  if (query) {
    return [name, ...models, { queryParams: query }];
  }

  return [name, ...models];
}

export class SpotifyAuthRoute extends Route {
  @polarisService(SpotifyService) declare spotify: SpotifyService;
  @service declare router: RouterService;

  activate(transition: Transition) {
    if (isSSR()) {
      return;
    }

    if (Object.keys(transition.to?.queryParams as object).length > 0) {
      this.spotify.authenticate(deserialize(transition.to?.queryParams as Record<string, unknown>));

      const redirectAfterLogin = localStorage.getItem('redirectAfterLogin');

      if (redirectAfterLogin) {
        const [routeURL, qp] = redirectAfterLogin.split('?');
        const query = Object.fromEntries(new URLSearchParams(qp).entries());

        localStorage.removeItem('redirectAfterLogin');

        // ok, so "transitionTo(url)" will drop the query params, so let's do
        // this fancy thing here:
        const route = this.router.recognize(routeURL) as RouteInfo;
        const routeArgs = makeRouteArgs({
          name: route.name,
          models: Object.values(route.params as object) as RouteModel[],
          query: Object.keys(query).length > 0 ? query : undefined
        });

        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore glint, wh00t ?
        void this.router.transitionTo(...routeArgs);
      } else {
        void this.router.transitionTo('application');
      }
    }
  }
}
