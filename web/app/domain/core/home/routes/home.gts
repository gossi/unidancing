import { link } from 'ember-link';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Button, Page } from '@hokulea/ember';

import styles from './home.css';

class HomeRoute extends Route<object> {
  <template>
    <Page class={{styles.home}}>
      <:title>UniDancing</:title>
      <:description><i>Eine Bewegungskunst</i></:description>
      <:content>
        <section>
          <div>
            <h2>Moves &amp; Künste</h2>

            <p>
              Spezielle Auswahl von Bewegungen und Körpertechniken für Einradfahrer, die deiner Kür
              Charakter verleihen.
            </p>

            <div>
              <Button @push={{link "moves"}}>
                Moves
              </Button>

              <Button @push={{link "arts"}} @importance="subtle">
                Künste
              </Button>
            </div>
          </div>
        </section>

        <section>
          <div>
            <h2>Lernen</h2>

            <p>
              Nützliche Übungen und Kurse, die dir alle Grundlagen und wichtige Bewegungen
              beibringen.
            </p>

            <div>
              <Button @push={{link "exercises"}}>
                Übungen
              </Button>

              <Button @push={{link "courses"}} @importance="subtle">
                Kurse
              </Button>
            </div>
          </div>
        </section>

        <section>
          <div>
            <h2>Training</h2>

            <p>
              Für Trainer zur Planung und Gestaltung des Trainigs, sowie Diagnostik zur
              Leistungskontrolle.
            </p>

            <div>
              <Button @push={{link "training.planning.units"}}>
                Trainingsgestaltung
              </Button>

              <Button @push={{link "training.diagnostics"}} @importance="subtle">
                Diagnostik
              </Button>
            </div>
          </div>
        </section>
      </:content>
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(HomeRoute);
