import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { concat, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { next } from '@ember/runloop';

import { use } from 'ember-resources';
import { eq } from 'ember-truth-helpers';
import { TrackedObject, TrackedSet } from 'tracked-built-ins';
import { v4 as uuid } from 'uuid';

import { Button, Form, Icon, IconButton } from '@hokulea/ember';

import { findAwfulPractices } from '../../choreography';
import styles from './bingo.css';

import type { Awfulpractice } from '../../choreography';
import type { TOC } from '@ember/component/template-only';

interface TileSignature {
  Args: {
    principle: Awfulpractice;
    selected: boolean;
    winner: boolean;
    select: () => void;
  };
}

const Tile: TOC<TileSignature> = <template>
  <button
    type="button"
    class={{styles.tile}}
    data-winner={{@winner}}
    data-selected={{@selected}}
    {{on "click" @select}}
  >
    {{@principle.title}}
  </button>
</template>;

class Bingo {
  @tracked principles: Awfulpractice[];
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  @tracked selection: Set<Awfulpractice> = new TrackedSet();
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  @tracked winner: Set<Awfulpractice> = new TrackedSet();
  @tracked finished: boolean = false;

  private static STORAGE_PRINCIPLES: string = 'bullshit_bingo.principles';
  private static STORAGE_SELECTION: string = 'bullshit_bingo.selection';

  static hasSavegame() {
    const principles = window.localStorage.getItem(Bingo.STORAGE_PRINCIPLES);

    return Boolean(principles);
  }

  static loadSavegame(): Bingo | undefined {
    const data = window.localStorage.getItem(Bingo.STORAGE_PRINCIPLES);
    const selection = window.localStorage.getItem(Bingo.STORAGE_SELECTION);

    if (!data) {
      return;
    }

    const principles = JSON.parse(data) as Awfulpractice[];

    if (principles) {
      const game = new Bingo(principles);

      if (selection) {
        for (const s of JSON.parse(selection)) {
          game.selection.add(game.principles.find((p) => p.id === s.id) as Awfulpractice);
        }

        game.checkForWin();
      }

      return game;
    }

    return;
  }

  constructor(principles: Awfulpractice[]) {
    this.principles = principles;

    // clear local storage for a fresh game
    window.localStorage.removeItem(Bingo.STORAGE_PRINCIPLES);
    window.localStorage.removeItem(Bingo.STORAGE_SELECTION);

    // save new game
    this.persistPrinciples();
  }

  select = (principle: Awfulpractice) => {
    if (this.selection.has(principle)) {
      this.selection.delete(principle);
    } else {
      this.selection.add(principle);
    }

    // reset in case of unselect
    this.finished = false;
    this.winner.clear();

    this.checkForWin();
  };

  private checkForWin() {
    const winner = this.findWinner();

    if (winner !== undefined) {
      const [line, index] = winner;

      if (line === 'row') {
        const start = (index - 1) * 5;

        for (let i = start; i < start + 5; i++) {
          this.winner.add(this.principles[i]);
        }
      }

      if (line === 'col') {
        for (let i = 0; i < this.principles.length; i++) {
          if (this.getColumn(i + 1) === index) {
            this.winner.add(this.principles[i]);
          }
        }
      }

      if (line === 'cross') {
        for (let i = 0; i < this.principles.length; i++) {
          const row = this.getRow(i + 1);
          const col = this.getColumn(i + 1);

          if (index === 0 && row === col) {
            this.winner.add(this.principles[i]);
          }

          if (index === 1 && row + col === 6) {
            this.winner.add(this.principles[i]);
          }
        }
      }

      this.finished = true;
    }

    this.persistSelection();
  }

  findWinner(): [string, number] | undefined {
    if (this.principles.length === 0) {
      return undefined;
    }

    const rows: boolean[][] = [[], [], [], [], []];
    const cols: boolean[][] = [[], [], [], [], []];
    const cross: boolean[][] = [[], []];

    for (let i = 0; i < this.principles.length; i++) {
      const selected = this.selection.has(this.principles[i]);
      const index = i + 1;
      const row = this.getRow(index);
      const col = this.getColumn(index);

      rows[row - 1].push(selected);
      cols[col - 1].push(selected);

      if (row === col) {
        cross[0].push(selected);
      }

      if (row + col === 6) {
        cross[1].push(selected);
      }
    }

    const lines = [rows, cols, cross].reduce((acc, val) => acc.concat(val), []);
    const winnerLine = lines.findIndex((line) => line.every((v) => v === true));

    if (winnerLine >= 0 && winnerLine <= 4) {
      return ['row', winnerLine + 1];
    } else if (winnerLine >= 5 && winnerLine <= 9) {
      return ['col', winnerLine + 1 - 5];
    } else if (winnerLine >= 10) {
      return ['cross', winnerLine - 10];
    }

    return undefined;
  }

  private getRow(index: number): number {
    return Math.ceil(index / 5);
  }

  private getColumn(index: number): number {
    const col = index % 5;

    return col === 0 ? 5 : col;
  }

  private persistPrinciples() {
    window.localStorage.setItem(Bingo.STORAGE_PRINCIPLES, JSON.stringify(this.principles));
  }

  private persistSelection() {
    window.localStorage.setItem(
      Bingo.STORAGE_SELECTION,
      JSON.stringify(Array.from(this.selection))
    );
  }
}

interface Counter {
  id: string;
  name: string;
  count: number;
}

class Counters {
  private static STORAGE_COUNTER: string = 'bullshit_bingo.counter';
  private static STORAGE_ACTIVE_COUNTER_ID: string = 'bullshit_bingo.active_counter_id';

  @tracked counters: Record<string, Counter> = new TrackedObject();
  @tracked activeCounter!: Counter;

  constructor() {
    if (window !== undefined) {
      this.load();
    }

    if (Object.keys(this.counters).length === 0) {
      // eslint-disable-next-line ember/no-runloop
      next(this, this.init);
    }
  }

  load() {
    const activeCounter = window.localStorage.getItem(Counters.STORAGE_ACTIVE_COUNTER_ID);
    const data = window.localStorage.getItem(Counters.STORAGE_COUNTER);
    const counters: Record<string, Counter> = data ? new TrackedObject(JSON.parse(data)) : {};

    for (const [id, counter] of Object.entries(counters)) {
      this.counters[id] = new TrackedObject(
        counter as unknown as Record<string, string | number>
      ) as unknown as Counter;
    }

    if (activeCounter && Object.keys(this.counters).includes(activeCounter)) {
      this.activeCounter = this.counters[activeCounter];
    }
  }

  init() {
    const id = uuid();

    this.counters[id] = new TrackedObject({
      id,
      name: 'Standard',
      count: 0
    });
    this.activeCounter = this.counters[id];

    this.persistCounters();
  }

  activateCounter = (id: string) => {
    if (this.counters[id]) {
      this.activeCounter = this.counters[id];
      window.localStorage.setItem(Counters.STORAGE_ACTIVE_COUNTER_ID, id);
    }
  };

  renameCounter = (id: string, name: string) => {
    this.counters[id].name = name;
    // if (id === this.activeCounter.id) {
    //   this.activeCounter = this.counters[id];
    // }
    this.persistCounters();
  };

  incrementCounter(id: string) {
    this.counters[id].count++;
    // if (id === this.activeCounter.id) {
    //   this.activeCounter = this.counters[id];
    // }
    this.persistCounters();
  }

  incrementActiveCounter = () => {
    this.incrementCounter(this.activeCounter.id);
  };

  newCounter = (name: string) => {
    const cnt = new TrackedObject({
      id: uuid(),
      name: name,
      count: 0
    });

    this.counters[cnt.id] = cnt;
    this.persistCounters();
  };

  deleteCounter = (id: string) => {
    // eslint-disable-next-line @typescript-eslint/no-dynamic-delete
    delete this.counters[id];
    this.persistCounters();
  };

  persistCounters() {
    window.localStorage.setItem(Counters.STORAGE_COUNTER, JSON.stringify(this.counters));
    window.localStorage.setItem(Counters.STORAGE_ACTIVE_COUNTER_ID, this.activeCounter.id);
  }
}

function has(set: Set<unknown>, value: unknown): boolean {
  return set.has(value);
}

class CounterManager extends Component<{ Args: { counters: Counters } }> {
  newCounter = (data: { name: string }) => {
    const { name } = data;

    this.args.counters.newCounter(name);
    data.name = '';
  };

  renameCounter = (id: string, data: { name: string }) => {
    this.args.counters.renameCounter(id, data.name);
  };

  <template>
    <div class={{styles.counters}}>
      <h2>Zähler</h2>

      <p>
        Zähler können verwendet werden, um an bestimmten Ereignissen die Bingos zu zählen (zum
        Beispiel der Videoanalyse vergangener Wettkämpfe).
      </p>

      {{#each-in @counters.counters as |id counter|}}
        <Form
          @data={{hash name=counter.name}}
          @submit={{fn this.renameCounter id}}
          class={{styles.form}}
          as |f|
        >
          <f.Text @name="name" @label={{concat "Zählerstand: " counter.count}} />

          <f.Submit><Icon @icon="pencil" /></f.Submit>

          {{#if (eq id @counters.activeCounter.id)}}
            <IconButton @icon="check" @disabled={{true}} @label="Zähler aktiv" />
          {{else}}
            <IconButton
              @icon="arrow-right"
              @push={{fn @counters.activateCounter id}}
              @label="Zähler aktivieren"
            />
          {{/if}}

          <IconButton
            @intent="danger"
            @importance="subtle"
            @icon="trash"
            @push={{fn @counters.deleteCounter id}}
            @label="Zähler löschen"
          />
        </Form>
      {{/each-in}}

      <h3>Neuer Zähler</h3>

      <Form @data={{hash name=""}} @submit={{this.newCounter}} class="{{styles.form}}" as |f|>
        <f.Text @name="name" @label="Name für den Zähler" />

        <f.Submit><Icon @icon="plus" /></f.Submit>
      </Form>
    </div>
  </template>
}

export default class BingoComponent extends Component {
  principlesLoader = use(this, findAwfulPractices);

  @tracked principles: Awfulpractice[] = [];

  @tracked gamePrinciples: Awfulpractice[] = [];
  @tracked display: string = 'game';
  @tracked game?: Bingo;
  counters = new Counters();

  constructor(owner: unknown, args: object) {
    super(owner, args);

    this.load();
  }

  async load() {
    this.principles = await this.principlesLoader.current;

    if (Bingo.hasSavegame()) {
      this.game = Bingo.loadSavegame();
    }
  }

  toggle = () => {
    this.display = this.display === 'game' ? 'counter' : 'game';
  };

  start = () => {
    const principles = this.principles.sort(() => 0.5 - Math.random()).slice(0, 25);

    this.game = new Bingo(principles);
  };

  reset = () => {
    this.start();
  };

  newGame = () => {
    this.counters.incrementActiveCounter();
    this.start();
  };

  <template>
    <div class={{styles.bingo}}>
      <nav>
        <ul>
          <li>
            <Button @spacing="-1" @push={{this.toggle}}>
              {{#if (eq this.display "game")}}
                Zähler
              {{else}}
                Spielen
              {{/if}}
            </Button>
          </li>
          <li>
            {{this.counters.activeCounter.name}}:
            <span>{{this.counters.activeCounter.count}}</span>
          </li>
        </ul>

        {{#if (eq this.display "game")}}
          <ul>
            <li class="{{styles.bingoText}} {{if this.game.finished styles.bingoTextVisible}}">
              <span>B</span>
              <span>i</span>
              <span>n</span>
              <span>g</span>
              <span>o</span>
              <span>!</span>
            </li>
          </ul>
          <ul>
            {{#if this.game.finished}}
              <li><Button @spacing="-1" @importance="subtle" @push={{this.newGame}}>Nochmal Spielen</Button></li>
            {{else}}
              <li><Button @spacing="-1" @importance="subtle" @push={{this.reset}}>Neues Spiel</Button></li>
            {{/if}}
          </ul>
        {{/if}}
      </nav>

      {{#if (eq this.display "game")}}
        {{#if this.game}}
          <div class={{styles.playfield}}>
            {{#each this.game.principles as |principle|}}
              <Tile
                @principle={{principle}}
                @selected={{has this.game.selection principle}}
                @winner={{has this.game.winner principle}}
                @select={{fn this.game.select principle}}
              />
            {{/each}}
          </div>
        {{else}}
          <Button @push={{this.newGame}}>Neues Spiel</Button>
        {{/if}}
      {{else}}
        <CounterManager @counters={{this.counters}} />
      {{/if}}
    </div>
  </template>
}
