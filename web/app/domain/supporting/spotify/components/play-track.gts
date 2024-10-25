import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { fn } from '@ember/helper';

import { service } from 'ember-polaris-service';
import { use } from 'ember-resources';

import { AudioPlayer, AudioService } from '../../audio';
import { isAuthenticated } from '../abilities';
import { findTrack } from '../resources/track';
import { SpotifyService } from '../service';
import { SpotifyPlayButton } from './spotify-play-button';

import type { Track } from '../domain-objects';

interface PlayTrackSignature {
  Args: {
    track: Track | string;
    play: (track: Track) => void;
  };
}

export class PlayTrack extends Component<PlayTrackSignature> {
  @service(AudioService) declare audio: AudioService;
  @service(SpotifyService) declare spotify: SpotifyService;

  @tracked playStarted = false;

  constructor(owner: unknown, args: PlayTrackSignature['Args']) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    registerDestructor(this, () => {
      this.audio.player = undefined;

      if (this.playStarted && this.spotify.client.playing) {
        this.spotify.client.pause();
      }
    });
  }

  trackResource = use(
    this,
    findTrack(() => this.args.track)
  );

  get track() {
    return this.trackResource.current;
  }

  get intent() {
    return this.playStarted ? 'stop' : 'play';
  }

  toggle = (track: Track) => {
    this.playStarted = !this.playStarted;

    if (this.spotify.client.playing) {
      this.spotify.client.pause();
    } else {
      this.args.play(track);
    }
  };

  <template>
    {{#if (isAuthenticated)}}
      {{#if this.track}}
        <SpotifyPlayButton @intent={{this.intent}} @push={{fn this.toggle this.track}}>
          {{this.track.name}}
        </SpotifyPlayButton>
      {{/if}}
    {{else}}
      Login mit Spotify
    {{/if}}
  </template>
}
