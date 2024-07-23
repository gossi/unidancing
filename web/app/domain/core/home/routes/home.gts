import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { CardSection, Features, Icon } from '../../../supporting/ui';

class HomeRoute extends Route<object> {
  <template>
    <Page>
      <:title>UniDancing</:title>
      <:description><i>Eine Bewegungskunst</i></:description>
      <:content>
        <Features>
          <CardSection>
            <:header as |Headline|><Headline><Icon @icon='motion' /> Bewegungen</Headline></:header>
            <:body>
              <ul>
                <li>
                  <LinkTo @route='moves'>Moves</LinkTo><br>
                  Spezielle Auswahl von Bewegungen und Körpertechniken für
                  Einradfahrer, die deiner Kür Charakter verleihen.
                </li>
              </ul>
            </:body>
          </CardSection>

          <CardSection>
            <:header as |Headline|><Headline><Icon @icon='learn' /> Lernen</Headline></:header>

            <:body>
              <ul>
                <li><LinkTo @route='exercises'>Übungen</LinkTo><br>
                  mit denen du Bewegungen und Körperkunst lernst.</li>
                <li><LinkTo @route='courses'>Kurse</LinkTo><br>
                  zusammenhängenden Übungen für ein Lernziel.</li>
              </ul>
            </:body>
          </CardSection>

          <CardSection>
            <:header as |Headline|><Headline><Icon @icon='training' /> Training</Headline></:header>

            <:body>
              <ul>
                <li>
                  <LinkTo @route='training.planning'>Planung</LinkTo><br />
                  Trainingsgestaltung und Trainingspläne.
                </li>
                <li>
                  <LinkTo @route='training.control'>Steuerung</LinkTo><br />
                  Steuergrößen für das Kür-Training.
                </li>
                <li>
                  <LinkTo @route='training.diagnostics'>Diagnostik</LinkTo><br />
                  Kenngrößen und -werte für die Trainingsanalyse von Küren.
                </li>
              </ul>
            </:body>
          </CardSection>

          <CardSection>
            <:header as |Headline|><Headline><Icon @icon='literature' /> Nachlesen</Headline></:header>

            <:body>
              <ul>
                <li><LinkTo @route='choreography'>Choreographie</LinkTo> Hub</li>
                <li><LinkTo @route='skills'>Artistische Fertigkeiten</LinkTo></li>
              </ul>
            </:body>
          </CardSection>
        </Features>
      </:content>
    </Page>
  </template>
}

export default CompatRoute(HomeRoute);
