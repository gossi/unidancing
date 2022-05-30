import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import SpotifyService from '../../services/spotify';
import { Resource } from 'ember-resources/core';

// https://open.spotify.com/playlist/3qaxO2Z99batsuhi12MDsn?si=865135aca7b64c32

export class PlaylistsResource extends Resource {
  @service declare spotify: SpotifyService;

  @tracked playlists?: SpotifyApi.PlaylistObjectSimplified[];

  modify() {
    this.load();
  }

  private async load() {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    const response = await this.spotify.client.getUserPlaylists({
      limit: 50
    });

    this.playlists = response.items;

    // const response = await this.spotifyApi.getArtistAlbums(
    //   '43ZHCT0cAZBISjO8DG9PnE'
    // );
    console.log(response);
  }
}

export function usePlaylists(destroyable: object) {
  return PlaylistsResource.from(destroyable);
}
