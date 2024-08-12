import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { Note, Tag } from '../../../../supporting/ui';

export class TrainingPlanningUnitsRoute extends Route<object> {
  <template>
    <Page @title="Trainingsgestaltung">
      <p>Eine Trainingseinheit ist in Einleitung, Hauptteil und Schluss gegliedert. Jeder Teil will
        vorbereitet sein, um den Athleten die Trainingsziele zu vermitteln.</p>

      <h2>Übungen</h2>

      <p>
        Zur Trainingsgestaltung bieten sich die zahlreichen
        <LinkTo @route="exercises">Übungen</LinkTo>
        an. Die Übungen reichen von kurzen Sequenzen, etwa für's Aufwärmen bis zu einer Stunde
        füllendende Länge.
      </p>

      <p>Das Übungsangebot ist zur Orientierung mit Tags versehen und besteht u.a. aus:</p>

      <ul>
        <li><Tag>warmup</Tag> - Zum Aufwärmen</li>
        <li><Tag>choreo</Tag> - Am Stundenende gibt's ein Showcase</li>
      </ul>

      <h3>Vorbereitung</h3>

      <p>Als Trainer könnt (und sollt) ihr euer Training daheim in Ruhe vorbereiten. Evtl. die
        erforderlichen Inhalte einstudieren, um sie später im Training vorzuzeigen.</p>

      <p>Die Übungen stellen euch Medien, z.B.
        <LinkTo @route="exercises.details" @model="beginner-moves">Videos</LinkTo>
        oder
        <LinkTo @route="exercises.details" @model="melodie-vs-rythmus">Musik</LinkTo>
        direkt bereit.</p>

      <Note @indicator="warning">
        Die Spotify Integration ist noch experimentell und steht noch nicht für alle bereit - Wir
        arbeiten dran.
      </Note>

      <h2>Weitere Helfer</h2>

      <p>Für eure eigene kreative Trainingsgestaltung könnt ihr auf diese Helfer zurückgreifen.</p>

      <ul>
        <li>
          <LinkTo @route="training.planning.assistants">Trainingsassistenten</LinkTo><br />
          Interaktive Werkzeuge zur Trainingsgestaltung und -auswertung.
        </li>
        <li>
          <LinkTo @route="training.planning.games">Spiele</LinkTo><br />
          Zur spielerischen Gestaltung für das Training.
        </li>
      </ul>
    </Page>
  </template>
}

export default CompatRoute(TrainingPlanningUnitsRoute);
