import { cached } from '@glimmer/tracking';
import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';

import { Features, Section } from '@unidancing/app/domain/supporting/ui';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import {
  findRoutine,
  TimeTrackingBalanceIndicator,
  TimeTrackingEffectivityIndicator,
  TimeTrackingSummary
} from '../../../choreography';

import type { TimeAnalysis } from '../../../choreography/routines/analysis/time-tracking/domain';
import type FastbootService from 'ember-cli-fastboot/services/fastboot';

function asTimeAnalysis(data: TimeAnalysis | undefined): TimeAnalysis {
  return data as TimeAnalysis;
}

export class TrainingDiagnosticsTimeTrackingRoute extends Route<object> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findRoutine('unicon-16/kazuhiro-shimoyama')).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{pageTitle "Zeitaufteilung"}}

    <Page @title="Zeitaufteilung">
      {{#let this.load as |r|}}
        <p>Die Zeitaufteilung gibt einen interessanten Aufschluss über die Choreographie. Gemessen
          wird wieviel Zeit mit
          <b>Tricks</b>,
          <b>Artistik</b>,
          <b>Filler</b>
          und
          <b>Void</b>
          (nichts) verbracht wird.</p>

        <dl>
          <dt>Tricks</dt>
          <dd>Die Zeit, die für Tricks verwendet wird.</dd>

          <dt>Artistik</dt>
          <dd>Die Zeit, die für Artistik verwendet wird.</dd>

          <dt>Kommunikation</dt>
          <dd>Wenn Fahrer den "roten Faden" aufrecht erhalten und konstant das Publikum auf der
            Reise durch die Kür mitnehmen, dann muss das nicht zwingend hoch artistisch erfolgen.
            Kommunikation erfordert damit kein spezielles Tanz- oder Schauspieltraining und kann von
            jeder Person gezeigt werden.<br />
            Das beste Beispiel ist aber das hochschauen ins Publikum und ist insbesondere im
            Juniorenalter eine schwierige Herausforderung.
          </dd>

          <dt>Filler</dt>
          <dd>Überflüssige Zeit während Tricks, die die Bewegung für den Zuschauer berechenbar und
            damit uninteressant macht. Darunter zählen zum Beispiel zu lange Glidings, an deren Ende
            ein weiterer Trick (z.B. Tipspin) folgt, ein Übergang von Wheel-Walk ins Cross-Over (das
            Bein stochert ewig, ehe es das Pedal trifft) oder zu viele Hüpfer während einer
            Hopping-Serie.</dd>

          <dd>Wenn ein Trick gefahren wird nur zum Zweck damit er gewertet wird, dabei allerdings
            einen sinnvolleren Nutzen der Kürzeit verplempert. Wird zum Beispiel Cross-Over gefahren
            (ohne direkt in den Spin zu starten), so wird der Trick eine gewisse Zeit benötigen. Ist
            der Fahrer mit dem Trick überfordert, wird zu dieser Zeit keine artistische Performance
            stattfinden - die Auswahl des Tricks wird zum Beinstellen für die eigene Kür.</dd>

          <dd>Außerdem werden auch unnötige Ausgleichsbewegungen zur Herstellung des Gleichgewichts
            als Filler gezählt.</dd>

          <dt>Void</dt>
          <dd>Die Zeit, in der nichts passiert. Der Fahrer fährt vor sich hin, aber weder ein Trick
            noch Artistik werden gezeigt.</dd>

          <dt>Abstiege</dt>
          <dd>Zeit die für ungeplante Abstiege und auch des Wiederaufsteigen anfällt.</dd>
        </dl>

        <h2>Durchführung</h2>
        <p>
          Die Zeiten werden während einer Videoaufnahme gestoppt. Im Ergebnis steht zu jedem
          Messkriterium die gemessene Zeit. Die Messwerte werden in Relation zur Kürlänge gesetzt.
        </p>

        <h2>Auswertung</h2>

        <p>In der Auswertung sind zunächst die absolut gestoppten Zeiten, sowie deren Verhältnis zur
          Kürdauer deskriptiv notiert.</p>

        <p>
          Das Auswertungsbeispiel zur
          <LinkTo
            @route="choreography.routines.details"
            @model="unicon-16/kazuhiro-shimoyama"
          >Einzelkür von Kazuhiro Shimoyama an der Unicon 16 in Brixen (Italien)</LinkTo>
          listet die erfassten Merkmale und stellt sie tabellarisch dar.
        </p>

        {{#if r.resolved}}
          <TimeTrackingSummary @data={{asTimeAnalysis r.value.timeTracking}} />
        {{/if}}

        <p>Die Durchdringung von Artistik bei nicht vorhandenen Fillern und Void ist beeindruckend.
          Die Pause von Artistik kommt nur durch die Tricks zustande, die seine volle Aufmerksamkeit
          erfordern, sonst findet Artistik auch während Tricks statt.</p>

        <h3>Kenngröße: Effektivität</h3>

        <p>Die effektiv genutzte Zeit einer Kür lässt sich mathematisch berechnen. Basis hierfür
          sind die erfassten Merkmale, die die Attraktivität einer Kür erhöhen (Promotoren) bzw.
          senken (Detraktoren).</p>

        <Features>
          <Section>
            <:header>Promotoren</:header>
            <:body>
              <ul>
                <li>Artistik</li>
                <li>Kommunikation</li>
                <li>Tricks</li>
              </ul>
            </:body>
          </Section>

          <Section>
            <:header>Detraktoren</:header>
            <:body>
              <ul>
                <li>Filler</li>
                <li>Void</li>
                <li>Abstiege</li>
              </ul>
            </:body>
          </Section>
        </Features>

        <p>Summiert man die Promotoren und subtrahiert die Detraktoren lässt sich die effektiv
          genutzte Zeit für eine Kür berechnen.
        </p>

        <p>Der Effektivitätsindex ist die effektiv genutzte Zeit ins Verhältnis zur Kürdauer. Der
          Wertebereich liegt
          <i>theoretisch</i>
          bei (0, 2), da Tricks zeitgleich mit Artistik gezeigt werden kann. Ein Wert von 1
          bedeutet, dass die gesamte Kürzeit genutzt wurde.
        </p>

        {{#if r.resolved}}
          <TimeTrackingEffectivityIndicator @data={{asTimeAnalysis r.value.timeTracking}} />
        {{/if}}

        <h3>Kenngröße: Balance</h3>

        <p>Die Balance gibt das Verhältnis zwischen Artistik (inkl. Kommunikation) und Tricks an, um
          die Ausgewogenheit beider anzuzeigen.</p>

        {{#if r.resolved}}
          <TimeTrackingBalanceIndicator @data={{asTimeAnalysis r.value.timeTracking}} />
        {{/if}}
      {{/let}}
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingDiagnosticsTimeTrackingRoute);
