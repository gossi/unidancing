import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import { Icon } from '../domain/supporting/ui';
import { Player } from '../domain/supporting/audio';
import ApplicationController from './controller';
import styles from './styles.css';
import { on } from '@ember/modifier';
import { Game, buildGameLink, GameFactory } from '../domain/core/games';
import { Assistant, buildAssistantLink, AssistantFactory } from '../domain/core/assistants';
import { or } from 'ember-truth-helpers';

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
        <details class="dropdown">
          <summary role="link">
            <Icon @icon='choreo' />
            <span class={{styles.label}}>Choreographie</span>
          </summary>
          <ul dir="rtl">
            <li><LinkTo @route='choreography'>Übersicht</LinkTo></li>
            <li class={{styles.divider}}/>
            <li><LinkTo @route='choreography.unidance-writing'>UniDance Writing</LinkTo></li>
            <li><LinkTo @route='choreography.not-todo-list'>Not-Todo-Liste</LinkTo></li>
            <li class={{styles.divider}}/>
            <li class={{styles.title}}>Spiele</li>
            <li>
              {{#let (buildGameLink Game.Bingo) as |link|}}
                <a href={{link.url}} {{on 'click' link.transitionTo}}>Bingo</a>
              {{/let}}
            </li>
          </ul>
        </details>
      </li>
      <li>
        <details class="dropdown">
          <summary role="link">
            <Icon @icon='training' />
            <span class={{styles.label}}>Training</span>
          </summary>
          <ul dir="rtl">
            <li><LinkTo @route='training'>Übersicht</LinkTo></li>
            <li class={{styles.divider}}/>
            <li><LinkTo @route='training.planning'>Planung</LinkTo></li>
            <li><LinkTo @route='training.control'>Steuerung</LinkTo></li>
            <li><LinkTo @route='training.diagnostics'>Diagnostik</LinkTo></li>
            <li class={{styles.divider}}/>
            <li class={{styles.title}}>Assistenten</li>
            <li>
              {{#let (buildAssistantLink Assistant.DanceMix) as |link|}}
                <a href={{link.url}} {{on 'click' link.transitionTo}}>Dance Mix</a>
              {{/let}}
            </li>
            <li>
              {{#let (buildAssistantLink Assistant.Looper) as |link|}}
                <a href={{link.url}} {{on 'click' link.transitionTo}}>Loops</a>
              {{/let}}
            </li>
            <li class={{styles.title}}>Spiele</li>
            <li>
              {{#let (buildGameLink Game.DanceOhMat) as |link|}}
                <a href={{link.url}} {{on 'click' link.transitionTo}}>Dance Oh! Mat</a>
              {{/let}}
            </li>
          </ul>
        </details>
      </li>
      <li>
        <LinkTo @route='arts'>
          <Icon @icon='art' />
          <span class={{styles.label}}>Künste</span>
        </LinkTo>
      </li>
    </ul>
  </nav>

  <div class='container'>
    <div
      class='grid {{styles.main}}'
      data-game={{@controller.game}}
      data-assistant={{@controller.assistant}}
    >
      <main>
        {{outlet}}
      </main>

      {{#if (or @controller.game @controller.assistant)}}
        <aside>
          <button
            type='button'
            class='secondary outline {{styles.close}}'
            {{on 'click' @controller.close}}
          >X</button>
          {{#if @controller.game}}
            <GameFactory @game={{@controller.game}} />
          {{else if @controller.assistant}}
            <AssistantFactory @assistant={{@controller.assistant}} />
          {{/if}}
        </aside>
      {{/if}}
    </div>
  </div>

  <Player />
</template>);
