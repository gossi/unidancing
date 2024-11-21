import Component from '@glimmer/component';

import { modifier } from 'ember-modifier';
import getVideoId from 'get-video-id';
import YTPlayer from 'youtube-player';

import styles from './player.css';

import type { YouTubePlayer } from 'youtube-player/dist/types';

/**
 * https://developers.google.com/youtube/player_parameters#Parameters
 */
interface Parameters {
  autoplay?: 0 | 1 | undefined;
  // eslint-disable-next-line @typescript-eslint/naming-convention
  cc_lang_pref?: string | undefined;
  // eslint-disable-next-line @typescript-eslint/naming-convention
  cc_load_policy?: 1 | undefined;
  color?: 'red' | 'white' | undefined;
  controls?: 0 | 1 | undefined;
  disablekb?: 0 | 1 | undefined;
  enablejsapi?: 0 | 1 | undefined;
  end?: number | undefined;
  fs?: 0 | 1 | undefined;
  hl?: string | undefined;
  // eslint-disable-next-line @typescript-eslint/naming-convention
  iv_load_policy?: 1 | 3 | undefined;
  list?: string | undefined;
  listType?: 'playlist' | 'search' | 'user_uploads' | undefined;
  loop?: 0 | 1 | undefined;
  modestbranding?: 1 | undefined;
  origin?: string | undefined;
  playlist?: string | undefined;
  playsinline?: 0 | 1 | undefined;
  rel?: 0 | 1 | undefined;
  start?: number | undefined;
  // eslint-disable-next-line @typescript-eslint/naming-convention
  widget_referrer?: string | undefined;
}

const parseUrl = (url: string, options?: Parameters) => {
  const embedUrl = new URL('https://www.youtube.com');
  const u = new URL(url);

  const { id } = getVideoId(url);

  embedUrl.pathname = `embed/${id}`;

  if (u.searchParams.has('t')) {
    embedUrl.searchParams.set('start', u.searchParams.get('t') as string);
  }

  for (const [k, v] of Object.entries(options ?? {})) {
    embedUrl.searchParams.set(k, v);
  }

  return embedUrl.toString();
};

export class YoutubePlayer extends Component<{
  Element: HTMLIFrameElement;
  Args: {
    url: string;
    options?: Parameters;
    api?: (player: YouTubePlayer) => void;
  };
}> {
  player = modifier((elem: HTMLIFrameElement) => {
    const player = YTPlayer(elem);

    this.args.api?.(player);

    return () => {
      player.destroy();
    };
  });

  <template>
    <iframe
      class={{styles.player}}
      src={{parseUrl @url @options}}
      title="YouTube video player"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
      allowfullscreen
      {{this.player}}
      ...attributes
    ></iframe>
  </template>
}
