import styles from './styles.css';
import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingDiagnosticsIndexRoute extends Route<{}> {
  <template>
    <h2>Diagnostik</h2>

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
      <article>
        <header>
          <LinkTo @route="training.diagnostics.time-tracking">Zeitaufteilung</LinkTo>
        </header>
        Die Zeitaufteilung gibt einen interessanten Aufschluss über die Choreographie. Gemessen wird
        wieviel Zeit mit
        <b>Tricks</b>,
        <b>Artistik</b>,
        <b>Filler</b>
        und
        <b>Nichts</b>
        verbracht wird. Aus diesem Test liegen vier Kenngrößen vor.
      </article>

      {{!-- <article>
        <header>
          Dynamik (?)
        </header>
        <p>Dynamik als Kenngröße für „interessante/ansprechende“ Küren?</p>

        <p>=> Von dem, was die Musik hergibt + was der Fahrer kann, liegt die aktuelle Dynamik bei x%</p>
      </article> --}}

      <article>
        <header>
          <LinkTo @route="training.diagnostics.body-language">Artistik &amp; Körpersprache</LinkTo>
        </header>
        Welche Kunst wird vom Fahrer wie gut kommuniziert? Hiermit lässt es sich herausfinden.
      </article>

      <article>
        <header>
          Trickqualität
        </header>
        Ist die Trickqualität einer Kür würdig? Es gibt einen gravierenden Unterschied zwischen "Einen
        Trick landen" und "Einen Trick auf Kürqualität fahren".
      </article>
    </div>
  </template>
}

export default CompatRoute(TrainingDiagnosticsIndexRoute);
