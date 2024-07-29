import styles from './video-player.css';

import type { TOC } from '@ember/component/template-only';

const parseUrl = (url: string) => {
  const embedUrl = new URL('https://www.youtube.com');
  const u = new URL(url);

  const id = u.searchParams.has('v')
    // youtube.com/watch?v={id}
    ? u.searchParams.get('v')
    // youtu.be/{id}
    : u.pathname;

  embedUrl.pathname = `embed/${id}`;

  if (u.searchParams.has('t')) {
    embedUrl.searchParams.set('start', u.searchParams.get('t') as string);
  }

  return embedUrl.toString();
};

const VideoPlayer: TOC<{ Element: HTMLIFrameElement; Args: { url: string; }}> = <template>
  <iframe
    class={{styles.player}}
    src={{parseUrl @url}}
    title='YouTube video player'
    frameborder='0'
    allow='accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
    allowfullscreen
    ...attributes
  ></iframe>
</template>

export { VideoPlayer };
