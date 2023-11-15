import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import Icon from '../components/icon';
import { Player } from '../audio';
import { link } from 'ember-link';
import ApplicationController from './controller';
import { on } from '@ember/modifier';
import Game from '../games/game';
import styles from './styles.css';

interface Signature {
  Args: {
    controller: ApplicationController;
  };
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle 'UniDancing'}}

  <nav class='container-fluid {{styles.nav}}'>
    <ul>
      <li><LinkTo @route='application'><strong>UniDancing</strong></LinkTo></li>
      <li>
        <LinkTo @route='moves'>
          <Icon @icon='move' />
          <span class={{styles.label}}>Moves</span>
        </LinkTo>
      </li>
      <li>
        <LinkTo @route='exercises'>
          <Icon @icon='exercise' />
          <span class={{styles.label}}>Übungen</span>
        </LinkTo>
      </li>
      <li>
        <LinkTo @route='courses'>
          <Icon @icon='course' />
          <span class={{styles.label}}>Kurse</span>
        </LinkTo>
      </li>
      <li>
        <LinkTo @route='choreography'>
          <Icon @icon='choreo' />
          <span class={{styles.label}}>Choreographie</span>
        </LinkTo>
      </li>
      <li>
        <LinkTo @route='training'>
          <Icon @icon='training' />
          <span class={{styles.label}}>Training</span>
        </LinkTo>
      </li>
    </ul>

    <ul>
      <li>
        <details role='list' dir='rtl'>
          <summary aria-haspopup='listbox' role='link'>
            <span>
              <Icon @icon='game' />
              <span class={{styles.label}}>Games</span>
            </span>
          </summary>
          <ul role='listbox' dir='ltr'>
            {{#let (@controller.buildGameLink @controller.Game.DanceMix) as |link|}}
              <li><a href={{link.url}} {{on 'click' link.transitionTo}}>Dance Mix</a></li>
            {{/let}}

            {{#let (link 'games' @controller.Game.DanceOhMat) as |link|}}
              <li><a href={{link.url}} {{on 'click' link.transitionTo}}>Dance Oh! Mat</a></li>
            {{/let}}

            {{#let (link 'games' @controller.Game.Bingo) as |link|}}
              <li><a href={{link.url}} {{on 'click' link.transitionTo}}>Bingo</a></li>
            {{/let}}

            {{#let (link 'games' @controller.Game.Loops) as |link|}}
              <li><a href={{link.url}} {{on 'click' link.transitionTo}}>Loops</a></li>
            {{/let}}
          </ul>
        </details>
      </li>
    </ul>
  </nav>

  <div class='container'>
    <div class='grid {{styles.main}}' data-game={{@controller.game}}>
      <main>
        {{outlet}}
      </main>

      {{#if @controller.game}}
        <aside>
          <button
            type='button'
            class='secondary outline {{styles.close}}'
            {{on 'click' @controller.close}}
          >X</button>
          <Game @game={{@controller.game}} />
        </aside>
      {{/if}}
    </div>
  </div>

  <Player />
</template>);
