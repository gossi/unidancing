import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Icon } from '@hokulea/ember';

import styles from './styles.css';

export class ArtsIndexRoute extends Route<object> {
  <template>
    <div class={{styles.index}}>
      <p>Kurze Vorstellung der Kunstformen inklusive Geschichte und historische Relevanz, sowie die
        <LinkTo @route="moves">Moves</LinkTo>
        und
        <LinkTo @route="exercises">Übungen</LinkTo>
        die diesen Kunstformen zugeschrieben werden können.</p>

      <p><Icon @icon="arrow-left" /> Kunstform auswählen</p>
    </div>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ArtsIndexRoute);
