import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { findGame } from '../games';

import type { Game } from '../games';

export class GamesRoute extends Route<{ game: string }> {
  get Game() {
    return findGame(this.params.game as Game);
  }

  <template>
    {{#if this.Game}}
      <Page>
        <this.Game />
      </Page>
    {{/if}}
  </template>
}

export default CompatRoute(GamesRoute);
