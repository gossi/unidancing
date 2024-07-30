import { LinkTo } from '@ember/routing';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { Features, Section } from '../../../../supporting/ui';
import styles from './styles.css';

import type { TOC } from '@ember/component/template-only';

const Comparison: TOC<{ Blocks: { pro: []; contra: [] } }> = <template>
  <Features class={{styles.comparison}}>
    <Section>
      <:header>Vorteile</:header>
      <:body>
        {{yield to='pro'}}
      </:body>
    </Section>

    <Section>
      <:header>Nachteile</:header>
      <:body>
        {{yield to='contra'}}
      </:body>
    </Section>
  </Features>
</template>;

export class TrainingDiagnosticsBodyLanguageRoute extends Route<object> {
  <template>
    {{pageTitle 'Artistik & Körpersprache'}}

    <Page @title="Artistik &amp; Körpersprache">
      <p>Hierbei geht es um das Beurteilen von Durchdringung und Präsenz von Artistik und Körpersprache
        während einer Kür. Bei dieser Methode werden Kostüm und Musik für den Zuschauer ausgesetzt, um
        damit verbundene Assoziationen auszuschalten. Anhand dieser Methode lässt sich der Inhalt und
        die Aussage
        {{!(siehe \fullref{sec:Unidancing_Umsetzung})}}
        einer Kür erkennen. Im Gegensatz zu den vorigen drei diagnostischen Tests, wird hierbei keine
        objektive Kenngröße ermittelt. Es handelt sich vielmehr um eine Methode, die durch Kostüm und
        Musik getrübte Sicht auf eine Kür deutlich zu machen, um die subjektive Interpretation der Kür
        unter der Vorgabe des selbst gewählten Rahmens zu fokussieren.</p>

      <h2>Durchführung</h2>

      <p>Voraussetzung hierfür ist, dass der Fahrer in Trainingsklamotten fährt.</p>

      <h3>1. Während des Fahrens: Kopfhöhrer</h3>

      <p>Der Fahrer kann im Training nur mit Kopfhörer fahren, sodass er selbst die Musikstellen hören
        kann, um die Bewegungen entsprechend auszuführen. Diese Methode bietet sich daher nur für
        Einzelküren an.</p>

      <Comparison>
        <:pro>
          <ul>
            <li>Der Trainer kann das Ergebnis direkt sehen und verarbeiten.</li>
            <li>Schnelles Verfahren; spart Zeit.</li>
          </ul>
        </:pro>
        <:contra>
          <ul>
            <li>Der Fahrer sieht sich selbst nicht und muss sich beim Feedback komplett auf den Trainer
              verlassen.</li>
          </ul>
        </:contra>
      </Comparison>

      <h3>2. Nach dem Fahren: Stummes Video</h3>

      <p>Während dem Training wird die Kür auf Video aufgezeichnet. Im Nachträglichen Betrachten kann
        der Ton ausgeschaltet werden. Hierfür ist die Kamera eines aktuellen Smartphones ausreichend.</p>

      <Comparison>
        <:pro>
          <ul>
            <li>Der Fahrer können sich selbst danach ansehen und mit dem Trainer einzelne Stellen
              besprechen.</li>
            <li>Für Paarküren und Gruppenküren geeignet.</li>
            <li>Das Video lässt sich für weitere Messungen verwenden (z.B.
              <LinkTo @route='training.diagnostics.time-tracking'>Zeitaufteilung</LinkTo>)</li>
          </ul>
        </:pro>
        <:contra>
          <ul>
            <li>Es wird die doppelte Zeit benötigt, da zuerst die Kür gefahren wird, danach angeschaut.</li>
          </ul>
        </:contra>
      </Comparison>

      <h3>3. Kombinierte Methode</h3>
      <p>Um die Vorteile beider Methoden zu nutzen und einige Nachteile aufzuwiegen, lassen sich beide
        Methoden kombinieren. Der Fahrer fährt mit Kopfhörer und wird dabei gefilmt. Der Trainer kann
        sich bereits während der Aufnahme einige Gedanken machen und später, bei der Videoanalyse, mit
        dem Fahrer zu besprechen.</p>

      <Comparison>
        <:pro>
          <ul>
            <li>Der Fahrer können sich selbst danach ansehen und mit dem Trainer einzelne Stellen
              besprechen.</li>
          </ul>
        </:pro>
        <:contra>
          <ul>
            <li>Nur für die Einzelkür geeignet.</li>
          </ul>
        </:contra>
      </Comparison>

      <h2>Auswertung</h2>
      <p>Bei dieser Betrachtung fallen die Bewegungen der Artistik besonders auf und lassen sich
        bewerten. Hierzu muss man sich die Frage stellen, ob die dadurch sichtbaren Inhalte und Aussagen
        in den selbst vorgegebenen Rahmen der Kür passen (siehe dazu
        \fullref{sec:Unidancing_Umsetzung}). Wenn das nicht der Fall ist, so müssen die entsprechenden
        Stellen ausgebessert werden. Besonders interessant ist hier der Vergleich mit anderen Küren.
        Sind zwischen mehreren Küren, die in unterschiedlichen Rahmen festgelegt sind, die gleichen
        Bewegungen zu finden, dann ist die Einzigartigkeit der Kür nicht gegeben bzw. der Rahmen wird
        nicht distinktiv genug ausgefüllt. Folglich sollten sich die Bewegungen mehr von den anderen
        Küren, unter der Prämisse, dass der eigene Rahmen eingehalten wird, abgrenzen.</p>

      <p>Weiters lässt sich mit dieser Methode auch die Dynamik einer Kür gut erkennen. Ist die Kür
        abwechslungsreich gestaltet und lässt keine Vorahnung auf die nächsten Bewegungen zu? Oder ist
        die Kür monoton ausgerichtet und die nächsten Bewegungen sind durch diverse Anläufe, o.ä.
        gekennzeichnet und nehmen dem Zuschauer die Spannung?</p>

      <p>Kombiniert man die hier gefundenen Ergebnisse mit der Metrik der
        <LinkTo @route='training.diagnostics.time-tracking'>Zeitaufteilung</LinkTo>, so lässt sich
      deutlich erkennen, an welchen Stellen eine Ausbesserung stattfinden
      muss.</p>
    </Page>
  </template>
}

export default CompatRoute(TrainingDiagnosticsBodyLanguageRoute);
