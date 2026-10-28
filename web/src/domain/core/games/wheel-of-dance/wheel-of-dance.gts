import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';

import { AudioPlayer, AudioService } from '@unidancing/app/domain/supporting/audio';
import {
  getRandomTrack,
  getTracks,
  loadPlaylist,
  playTrackForDancing,
  WithSpotify
} from '@unidancing/app/domain/supporting/spotify';
import { SpotifyService } from '@unidancing/app/domain/supporting/spotify/service';
import { useMachine } from '@unidancing/app/domain/supporting/statechart';
import { CountDown, SlotMachine } from '@unidancing/app/domain/supporting/ui';
import { asNumber } from '@unidancing/app/domain/supporting/utils';
import { service as polarisService } from 'ember-polaris-service';
import { use } from 'ember-resources';
import Portal from 'ember-stargate/components/portal';
import PortalTarget from 'ember-stargate/components/portal-target';
import { assertEvent, assign } from 'xstate';

import IconGear from '~icons/ph/gear';

import { Button, Form, IconButton, Page } from '@hokulea/ember';

import { asContext, asDanceStyles, Genres, Playlists } from './data';
import { Machine } from './state';

import type { Context, DanceStyle, Genre } from './data';
import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';

interface LobbySignature {
  Args: {
    data: Partial<Context>;
    play: (params: Context) => void;
  };
}

const Lobby: TOC<LobbySignature> = <template>
  <Form @data={{@data}} @submit={{@play}} as |f|>
    <f.Number @name="duration" @label="Dauer pro Lied [sec]" />
    <f.Number @name="preparation" @label="Vorbereitungszeit [sec]" />
    <f.Submit>Start</f.Submit>
  </Form>
</template>;

class Game extends Component {
  @polarisService(SpotifyService) declare spotify: SpotifyService;
  @polarisService(AudioService) declare audio: AudioService;

  genre?: Genre;

  @cached
  get playlistResources() {
    return Object.fromEntries(
      Object.entries(Playlists).map(([k, v]) => {
        return [k, use(this, loadPlaylist(v))];
      })
    );
  }

  @cached
  get playlists() {
    return Object.fromEntries(
      Object.entries(this.playlistResources).map(([k, v]) => {
        return [k, v.current];
      })
    );
  }

  playTrackForDancing = playTrackForDancing(getOwner(this) as Owner);

  constructor(owner: Owner, args: object) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    // load resources
    // @ts-expect-error well, the "unused" is still the loading
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { playlists } = this;

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });
  }

  rollHandler = (e: KeyboardEvent) => {
    if (e.key === ' ') {
      this.machine.send('roll');
    }
  };

  startSelection = () => {
    const rollButton = document.querySelector<HTMLButtonElement>('#roll');

    rollButton?.focus();

    document.addEventListener('keydown', this.rollHandler);
  };

  stopSelection = () => {
    document.removeEventListener('keydown', this.rollHandler);
  };

  // ACTIONS

  roll = () => {
    void this.audio.soundboard.play('slot-machine-wheel');
  };

  dance = async ({ context }: { context: Context }) => {
    // @ts-expect-error yeah, but this is a given
    const track = getRandomTrack(getTracks(this.playlists[this.genre as Genre]));

    await this.playTrackForDancing(track, context.duration);
  };

  stop = async () => {
    await this.spotify.client.pause();
  };

  // NOTE: declared after all actions it references — `Machine.provide()`
  // resolves its implementation map at construction time, and the `roll` /
  // `dance` / ... entries capture the class fields right then. Class fields
  // evaluate in declaration order, so a `machine` field placed above the
  // actions would capture them as `undefined` here.
  machine = useMachine(this, () => ({
    machine: Machine.provide({
      /* eslint-disable @typescript-eslint/no-misused-promises -- xstate invokes actions
         without awaiting; the async bodies are fire-and-forget by design */
      actions: {
        play: assign(({ context, event }) => {
          assertEvent(event, 'play');

          return {
            ...context,
            duration: event.duration,
            preparation: event.preparation
          };
        }),
        dance: this.dance,
        stop: this.stop,
        roll: this.roll,
        startSelection: this.startSelection,
        stopSelection: this.stopSelection
      }
      /* eslint-enable @typescript-eslint/no-misused-promises */
    })
  }));

  // The Form's submit callback must return nothing: pahu reads a returned
  // value as the submit state (`undefined` passes, a stray object fails on
  // `state.issues.map`), so the callback body deliberately discards `send`'s
  // (non-)result — v5's `send` returns nothing.
  startGame = (params: Context) => {
    this.machine.send('play', params);
  };

  start = (data: Context) => {
    this.machine.send('start', data);
  };

  prepare = ({ genre }: { genre: Genre; style: DanceStyle }) => {
    this.genre = genre;
    this.machine.send('prepare');

    if (genre === 'Surprise') {
      void this.audio.soundboard.play('surprise');
    }
  };

  <template>
    <div class="canvas">

      {{#if (this.machine.state.matches "lobby")}}
        <Lobby @data={{asContext this.machine.state.context}} @play={{this.startGame}} />
      {{else}}
        <Portal @target="wof-header">
          <IconButton
            @icon={{IconGear}}
            @importance="subtle"
            @spacing="-1"
            @disabled={{this.machine.state.matches "dancing"}}
            @push={{fn this.machine.send "settings"}}
            @label="Anleitung"
          />
        </Portal>

        <SlotMachine
          @start={{this.machine.state.matches "rolling"}}
          @reset={{this.machine.state.matches "selecting"}}
          @drawn={{this.prepare}}
          class="slots"
          as |Slot|
        >
          <div>
            <h2>Dance Style</h2>
            <Slot @name="style" @options={{asDanceStyles this.machine.state.context.styles}} />
          </div>

          <div>
            <h2>Musik Genre</h2>
            <Slot @name="genre" @options={{Genres}} />
          </div>
        </SlotMachine>

        {{#if (this.machine.state.matches "selecting")}}
          <Button @push={{fn this.machine.send "roll"}} id="roll">Roll</Button>
        {{/if}}

        {{#if (this.machine.state.matches "preparing")}}
          <CountDown
            @duration={{asNumber this.machine.state.context.preparation}}
            @sound={{true}}
            @finished={{fn this.machine.send "dance"}}
          />
        {{/if}}

        {{#if (this.machine.state.matches "dancing")}}
          <CountDown
            @duration={{asNumber this.machine.state.context.duration}}
            @finished={{fn this.machine.send "stop"}}
          />

          <Button @push={{fn this.machine.send "stop"}}>Stop</Button>
        {{/if}}
      {{/if}}
    </div>

    <style scoped>
      .canvas {
        display: flex;
        flex-direction: column;
        gap: var(--spacing-container2);
        margin-block-start: var(--spacing-container4);
      }

      .slots {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(min(300px, 100%), 1fr));
        gap: var(--spacing-container0);

        & > div {
          display: grid;
          gap: var(--spacing-container0);

          padding: var(--spacing-container0);
          border-radius: var(--shape-radius-container);

          background: var(--surface-container1);

          h2 {
            text-align: center;
          }

          & > div {
            background: var(--surface-container);
          }
        }
      }
    </style>
  </template>
}

const WheelOfDance: TOC<object> = <template>
  <Page class="game">
    <:title>
      Wheel of Dance
      <PortalTarget @name="wof-header" class="toolbar" />
    </:title>
    <:content>
      <WithSpotify>
        <Game />
      </WithSpotify>
    </:content>
  </Page>
  <style scoped>
    .game :global(header h1) {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .toolbar {
      font-size: var(--s-1);
    }
  </style>
</template>;

export { WheelOfDance };
