import { Move } from '../../database/moves';
import Icon from '../../components/icon';
import VideoPlayer from '../../components/video-player';
import { Games } from '../../games/games';
import { Link } from 'ember-link';
import { on } from '@ember/modifier';
import { htmlSafe } from '@ember/template';
import styles from './details.css';
import { or } from 'ember-truth-helpers';

import type { TOC } from '@ember/component/template-only';

const parseUrl = (url: string) => {
  const embedUrl = new URL('https://www.youtube.com');
  const u = new URL(url);
  embedUrl.pathname = `embed/${u.pathname}`;

  if (u.searchParams.has('t')) {
    embedUrl.searchParams.set('start', u.searchParams.get('t') as string);
  }

  return embedUrl.toString();
};

export interface MoveDetailsSignature {
  Args: {
    move: Move;
    buildGameLink: <K extends keyof Games>(game: K, params?: Games[K]) => Link;
    buildSkillLink: (skill: string) => Link;
    buildMoveLink: (move: string) => Link;
  };
}

const MoveDetails: TOC<MoveDetailsSignature> = <template>
  <hgroup>
    <h1><Icon @icon='move' /> {{@move.title}}</h1>
    <span class={{styles.tagline}}>
      {{#each @move.tags as |tag|}}
        <code>{{tag}}</code>
      {{/each}}
    </span>
  </hgroup>

  <div class={{styles.layout}}>
    <section class={{styles.main}}>
      {{#if @move.games}}
        <header class={{styles.header}}>
          {{#each @move.games as |game|}}
            {{#let (@buildGameLink game.name game.params) as |link|}}
              <a href={{link.url}} role='button' {{on 'click' link.transitionTo}}>
                {{#if game.label}}{{game.label}}{{else}}{{game.name}}{{/if}}
              </a>
            {{/let}}
          {{/each}}
        </header>
      {{/if}}

      {{#if @move.video}}
        <VideoPlayer @url={{@move.video.url}} class={{styles.player}}/>
      {{/if}}

      {{htmlSafe @move.contents}}
    </section>
    <aside>
      {{#if (or @move.see @move.skills)}}
        <section>
          {{#if @move.see}}
            <nav>
              Siehe auch:

              <ul>
                {{#each @move.see as |see|}}
                  <li>
                    {{#if see.url}}
                      <a href={{see.url}} target='_blank'>
                        <Icon @icon='link' />
                        {{if see.label see.label see.url}}
                      </a>
                    {{else}}
                      {{#let (@buildMoveLink see.id) as |l|}}
                        <a href={{l.url}} {{on 'click' l.transitionTo}}>
                          <Icon @icon='move' />
                          {{see.title}}
                        </a>
                      {{/let}}
                    {{/if}}
                  </li>
                {{/each}}
              </ul>
            </nav>
          {{/if}}

          {{#if @move.skills}}
            <nav>
              Fertigkeiten:

              <ul>
                {{#each @move.skills as |skill|}}
                  <li>
                    {{#let (@buildSkillLink skill.id) as |l|}}
                      <a href={{l.url}} {{on 'click' l.transitionTo}}>
                        <Icon @icon='skill' />
                        {{skill.title}}
                      </a>
                    {{/let}}
                  </li>
                {{/each}}
              </ul>
            </nav>
          {{/if}}
        </section>
      {{/if}}
    </aside>
  </div>
</template>;

export default MoveDetails;
