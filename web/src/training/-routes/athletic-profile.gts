import { LinkTo } from '@ember/routing';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { CardSection, Features } from '../../../supporting/ui';

export class AthleticProfileRoute extends Route<object> {
  <template>
    {{pageTitle "Leistungsprofil"}}

    <Page @title="Leistungsprofil">
      <p>Leistungsvoraaussetzungen an Athleten zur Erbringung der Wettkampfleistung im UniDancing.</p>

      <h2>Technik — Koordination</h2>

      <p>
        Einradtricks,
        <LinkTo @route="moves">Tanzmoves</LinkTo>
        und weitere
        <LinkTo @route="arts">artistische Fertigkeiten</LinkTo>.
      </p>

      <p>Die Techniken machen den Hauptanteil der Wettkampfleistung aus.</p>

      <h2>Kondition</h2>

      <i>energetisch-konditionelle Leistungsvoraussetzungen</i>

      <Features>
        <CardSection>
          <:header><h3>Kraft</h3></:header>
          <:body>
            Die Kraftanforderungen ans UniDanicing haben einen unterstützenden Charakter.

            <ul>
              <li>Stütz- und Haltefunktionen primär des Rumpfes</li>
              <li>Isometrische Arbeitsweise bei 1ft-ext Tricks. </li>
              <li>Verletzungsprophylaxe</li>
            </ul>
          </:body>
        </CardSection>

        <CardSection>
          <:header><h3>Ausdauer</h3></:header>
          <:body>
            Die Wettkampfdauer beträgt maximal 5 Minuten für die Gruppenkür.

            <ul>
              <li>Azyklische Mittelzeitausdauer (2-10min)</li>
              <li>Herzfrequenz im Bereich 130-170</li>
              <li>Die Energiebereitstellung ist aerob/anaerob</li>
              <li>Bei hoch energetischen Bewegungen kann die Laktateliminierung eine Rolle spielen.</li>
            </ul>

            {{! <small>(Grosser, Starischka &amp; Zimmermann, S. 112ff)</small> }}
          </:body>
        </CardSection>
      </Features>

      <h2>Strategie und Taktik</h2>

      <p>Strategische Leistungsvoraussetzungen im UniDancing meint im weitesten Sinne ein
        Verständnis zu Gruppenkürfiguren. Z.B. welche Fahrwege lassen die Figur wirken und tragen
        essentiell zum Gelingen bei.</p>

      <p>Taktische Kentnisse erlauben das blitzschnelle handeln unter Einhaltung der strategischen
        Ausrichtung</p>

      <h2>Persönlichkeit — Handlungskompetenz</h2>
      <i></i>

      tbd.

      {{! <References as |l|>
        <l.Book
          @title="Das neue Konditionstraining"
          @year="2008"
          @edition="Zehnte, neu überarbeitete Auflage"
          @publisher="blv Sportwissen"
          as |b|
        >
          <b.Author @given="Manfred" @family="Grosser" />
          <b.Author @given="Stephan" @family="Starischka" />
          <b.Author @given="Elke" @family="Zimmermann" />
        </l.Book>
      </References> }}

    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(AthleticProfileRoute);
