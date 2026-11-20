import { link } from 'ember-link';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Button, Page } from '@hokulea/ember';

class HomeRoute extends Route<object> {
  <template>
    <Page class="home">
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

    {{!
      Intentionally global (<style> without `scoped`): the rule reaches into the
      hokulea <Page> implementation (`[part="content"]`), which is invisible to
      the template scoping. Keep in sync with the Page content block.
    }}
    <style>
      .home [part="content"] section {
        grid-template-columns: subgrid !important; /* important overwrites the handling for the game/assisstant dialog */
        padding-block: var(--spacing-container0);

        & > div {
          display: grid;
          flex-direction: column;
          gap: var(--spacing-container1);
        }

        &:nth-child(even) {
          display: grid;
          grid-column: 1 / 4;

          text-align: right;

          background-color: var(--surface-container1);
          clip-path: polygon(
            0 6%,
            /* left top */ 100% 0,
            /* right top */ 100% 94%,
            /* right bottom */ 0 100% /* left bottom */
          );

          & > div {
            grid-column: 2 / 3;
            width: var(--content-width);
            padding-block: var(--spacing-container0) var(--spacing-container2);
          }
        }
      }
    </style>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(HomeRoute);
