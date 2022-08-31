import { action } from '@ember/object';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import SpotifyService from '../services/spotify';
import { Player } from './player';
import { SpotifyTrackResource } from '../resources/spotify/track';
import { useTrack } from '../resources/spotify/track';

export default class SpotifyPlayer implements Player {
  @service declare spotify: SpotifyService;

  @tracked track?: SpotifyTrackResource;
  @tracked playing = false;

  private static instance?: SpotifyPlayer;

  private constructor() {
    // ...
  }

  static getInstance(): SpotifyPlayer {
    if (!SpotifyPlayer.instance) {
      SpotifyPlayer.instance = new SpotifyPlayer();
    }

    return SpotifyPlayer.instance;
  }

  async load() {
    const playing = await this.spotify.client.getMyCurrentPlayingTrack();
    if (playing?.item) {
      this.track = useTrack(this, { track: playing.item });
    }

    this.playing = playing.is_playing;
  }

  @action
  toggle() {
    if (this.playing) {
      this.pause();
    } else {
      this.play();
    }
  }

  @action
  play(options?: SpotifyApi.PlayParameterObject) {
    this.spotify.client.play(options);
    this.playing = true;
  }

  @action
  pause() {
    this.spotify.client.pause();
    this.playing = false;
  }
}
