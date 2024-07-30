import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Card,Page } from '@hokulea/ember';

import styles from './styles.css';

export class TrainingDiagnosticsIndexRoute extends Route<object> {
  <template>
    <Page @title="Diagnostik">
      <p>
        Teil der Leistungsdiagnostik ist es bestimmte Kenngrößen/-merkmale zu messen, diese Ergebnisse zu
        bewerten und beurteilen, um daraus Trainingsmaßnahmen abzuleiten.
      </p>

      <h3>Messverfahren</h3>

      <p>
        Hier werden Messverfahren vorgestellt, um zu prüfen, ob es sich um eine
        <i>spannende</i>
        Kür handelt.
      </p>

      <div class={{styles.measures}}>
        <Card>
          <:header>
            <LinkTo @route="training.diagnostics.time-tracking">Zeitaufteilung</LinkTo>
          </:header>
          <:body>
            Die Zeitaufteilung gibt einen interessanten Aufschluss über die Choreographie. Gemessen wird
            wieviel Zeit mit
            <b>Tricks</b>,
            <b>Artistik</b>,
            <b>Filler</b>
            und
            <b>Nichts</b>
            verbracht wird. Aus diesem Test liegen vier Kenngrößen vor.
          </:body>
        </Card>

        {{!-- <article>
          <header>
            Dynamik (?)
          </header>
          <p>Dynamik als Kenngröße für „interessante/ansprechende“ Küren?</p>

          <p>=> Von dem, was die Musik hergibt + was der Fahrer kann, liegt die aktuelle Dynamik bei x%</p>
        </article> --}}

        <Card>
          <:header>
            <LinkTo @route="training.diagnostics.body-language">Artistik &amp; Körpersprache</LinkTo>
          </:header>
          <:body>
            Welche Kunst wird vom Fahrer wie gut kommuniziert? Hiermit lässt es sich
            herausfinden.
          </:body>
        </Card>

        <Card>
          <:header>
            Trickqualität
          </:header>
          <:body>
          Ist die Trickqualität einer Kür würdig? Es gibt einen gravierenden Unterschied zwischen "Einen
          Trick landen" und "Einen Trick auf Kürqualität fahren".
          </:body>
        </Card>
      </div>
    </Page>
  </template>
}

export default CompatRoute(TrainingDiagnosticsIndexRoute);
