import config from '@unidancing/app/config/environment';
import Service from 'ember-polaris-service';

import type { youtube_v3 } from '@googleapis/youtube';

export class YoutubeService extends Service {
  // eslint-disable-next-line @typescript-eslint/no-unnecessary-type-parameters
  async #request<R extends object, P extends object = Record<string, string | string[]>>(
    endpoint: string,
    params: P
  ): Promise<R> {
    const url = new URL(`/youtube/v3/${endpoint}`, 'https://www.googleapis.com');
    const p = url.searchParams;

    for (const [k, v] of Object.entries(params)) {
      if (Array.isArray(v)) {
        for (const val of v) {
          p.append(k, val as string);
        }
      } else {
        p.set(k, v as string);
      }
    }

    console.log(config.APP.YOUTUBE_API_KEY);

    p.set('key', config.APP.YOUTUBE_API_KEY);

    let response = await fetch(url);

    if (!response.ok) {
      throw new Error('Failed to fetch YouTube videos');
    }

    const data = (await response.json()) as R | undefined;

    if (!data) {
      throw new Error('Failed to fetch YouTube videos');
    }

    return data;
  }

  async getVideo(id: string, params?: youtube_v3.Params$Resource$Videos$List) {
    return this.#request<
      youtube_v3.Schema$VideoListResponse,
      youtube_v3.Params$Resource$Videos$List
    >('videos', {
      part: ['contentDetails', 'snippet'],
      id: [id],
      ...params
    });
  }
}
