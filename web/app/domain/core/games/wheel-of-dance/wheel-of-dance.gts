import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { fn } from '@ember/helper';
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
import { CountDown, SlotMachine } from '@unidancing/app/domain/supporting/ui';
import { asNumber } from '@unidancing/app/domain/supporting/utils';
import { service as polarisService } from 'ember-polaris-service';
import { use } from 'ember-resources';
import Portal from 'ember-stargate/components/portal';
import PortalTarget from 'ember-stargate/components/portal-target';
import { useMachine } from 'ember-statecharts';
import { assign } from 'xstate';

import { Button, Form, IconButton } from '@hokulea/ember';

import { asContext, asDanceStyles, Genres, Playlists } from './data';
import { Machine } from './state';
import styles from './wheel-of-dance.css';

import type { Context, Genre } from './data';
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

  machine = useMachine(this, () => {
    const { play, dance, stop, startSelection, stopSelection, roll } = this;

    return {
      machine: Machine.withConfig({
        actions: { play, dance, stop, roll, startSelection, stopSelection }
      })
    };
  });

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
  play = assign((context, event: Context) => {
    return {
      ...context,
      duration: event.duration,
      preparation: event.preparation
    };
  });

  roll = () => {
    void this.audio.soundboard.play('slot-machine-wheel');
  };

  dance = async (context: Context) => {
    const track = getRandomTrack(getTracks(this.playlists[this.genre as Genre]));

    await this.playTrackForDancing(track, context.duration);
  };

  stop = async () => {
    await this.spotify.client.pause();
  };

  start = (data: Context) => {
    this.machine.send('start', data);
  };

  prepare = ({ genre }: { genre: Genre }) => {
    this.genre = genre;
    this.machine.send('prepare');

    if (genre === 'Surprise') {
      void this.audio.soundboard.play('surprise');
    }
  };

  <template>
    <div class={{styles.canvas}}>

      {{#if (this.machine.state.matches "lobby")}}
        <Lobby
          @data={{asContext this.machine.state.context}}
          @play={{fn this.machine.send "play"}}
        />
      {{else}}
        <Portal @target="wof-header">
          <IconButton
            @icon="gear"
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
          class={{styles.slots}}
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
  </template>
}

const WheelOfDance: TOC<object> = <template>
  <section class={{styles.game}}>
    <header>
      <h1>Wheel of Dance</h1>
      <div>
        <PortalTarget @name="wof-header" />
      </div>
    </header>

    <WithSpotify>
      <Game />
    </WithSpotify>
  </section>
</template>;

export { WheelOfDance };
