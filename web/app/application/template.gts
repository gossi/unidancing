import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import RouteTemplate from 'ember-route-template';
import { or } from 'ember-truth-helpers';

import { AppHeader, IconButton } from '@hokulea/ember';

import { Assistant, AssistantFactory, buildAssistantLink } from '../domain/core/assistants';
import { buildGameLink, Game, GameFactory } from '../domain/core/games';
import { Player } from '../domain/supporting/ui';
import styles from './styles.css';

import type ApplicationController from './controller';

interface Signature {
  Args: {
    controller: ApplicationController;
  };
}

export default RouteTemplate<Signature>(
  <template>
    {{pageTitle "UniDancing"}}

    <AppHeader @home={{link "application"}}>
      <:brand>UniDancing</:brand>
      <:nav as |n|>
        <n.Item @push={{link "moves"}}>Moves</n.Item>
        <n.Item @push={{link "exercises"}}>Übungen</n.Item>
        <n.Item @push={{link "courses"}}>Kurse</n.Item>
        <n.Item>
          <:label>Choreographie</:label>
          <:menu as |c|>
            <c.Item @push={{link "choreography"}}>Übersicht</c.Item>
            <hr />
            <c.Item @push={{link "choreography.unidance-writing"}}>UniDance Writing</c.Item>
            <c.Item @push={{link "choreography.not-todo-list"}}>Not-Todo-Liste</c.Item>
            <hr />
            <span class={{styles.label}}>Spiele</span>
            {{#let (buildGameLink Game.Bingo) as |bingoLink|}}
              <c.Item @push={{bingoLink}}>Bingo</c.Item>
            {{/let}}
          </:menu>
        </n.Item>
        <n.Item>
          <:label>Training</:label>
          <:menu as |t|>
            <t.Item @push={{link "training"}}>Übersicht</t.Item>
            <hr />
            <t.Item @push={{link "training.athletic-profile"}}>Leistungsprofil</t.Item>
            <t.Item @push={{link "training.planning"}}>Planung</t.Item>
            <t.Item @push={{link "training.control"}}>Steuerung</t.Item>
            <t.Item @push={{link "training.diagnostics"}}>Diagnostik</t.Item>
            <hr />

            <span class={{styles.label}}>Assistenten</span>
            {{#let (buildAssistantLink Assistant.DanceMix) as |danceMixLink|}}
              <t.Item @push={{danceMixLink}}>Dance Mix</t.Item>
            {{/let}}
            {{#let (buildAssistantLink Assistant.Looper) as |loopsLink|}}
              <t.Item @push={{loopsLink}}>Loops</t.Item>
            {{/let}}

            <span class={{styles.label}}>Spiele</span>
            {{#let (buildGameLink Game.DanceOhMat) as |danceOhMatLink|}}
              <t.Item @push={{danceOhMatLink}}>Dance Oh! Mat!</t.Item>
            {{/let}}
          </:menu>
        </n.Item>
        <n.Item @push={{link "arts"}}>Künste</n.Item>
      </:nav>
    </AppHeader>

    {{outlet}}

    {{#if (or @controller.game @controller.assistant)}}
      <dialog data-game={{@controller.game}} data-assistant={{@controller.assistant}} open>
        <IconButton
          @icon="x"
          @label="Schließen"
          @importance="plain"
          @push={{@controller.close}}
          part="close"
        />
        {{#if @controller.game}}
          <GameFactory @game={{@controller.game}} />
        {{else if @controller.assistant}}
          <AssistantFactory @assistant={{@controller.assistant}} />
        {{/if}}
      </dialog>
    {{/if}}

    <Player />
  </template>
);
