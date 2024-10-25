import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { asGame, findGame, getGameTitle } from '../games';

import type { Game } from '../games';

export class GamesRoute extends Route<{ game: Game }> {
  // eslint-disable-next-line @typescript-eslint/naming-convention
  get Game() {
    return findGame(this.params.game as Game);
  }

  <template>
    {{#if this.Game}}
      {{pageTitle (getGameTitle (asGame this.params.game))}}
      <Page>
        {{! @glint-ignore }}
        <this.Game />
      </Page>
    {{/if}}
  </template>
}

export default CompatRoute(GamesRoute);
