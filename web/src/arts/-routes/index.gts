import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import IconArrowLeft from '~icons/ph/arrow-left';

import { Icon } from '@hokulea/ember';

export class ArtsIndexRoute extends Route<object> {
  <template>
    <div class="content">
      <p>Kurze Vorstellung der Kunstformen inklusive Geschichte und historische Relevanz, sowie die
        <LinkTo @route="moves">Moves</LinkTo>
        und
        <LinkTo @route="exercises">Übungen</LinkTo>
        die diesen Kunstformen zugeschrieben werden können.</p>

      <p><Icon @icon={{IconArrowLeft}} /> Kunstform auswählen</p>
    </div>

    <style scoped>
      .content {
        display: flex;
        flex-direction: column;
        gap: var(--spacing-primitive0);
      }
    </style>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ArtsIndexRoute);
