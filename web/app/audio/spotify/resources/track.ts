import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';

import { Resource } from 'ember-resources';

import type { Track } from '../domain-objects';
import type { Registry as Services } from '@ember/service';
import type { ArgsWrapper } from 'ember-resources';

interface TrackArgs extends ArgsWrapper {
  named: {
    id?: string;
    track?: Track;
  };
}

export class TrackResource extends Resource<TrackArgs> {
  @service declare spotify: Services['spotify'];

  #cache: Map<string, Record<string, unknown>>;

  @tracked data?: Track;
  @tracked analysis?: Record<string, unknown>;

  constructor(owner: unknown) {
    super(owner);

    const cache = JSON.parse(localStorage.getItem('track-analysis') ?? '{}') as object;

    this.#cache = new Map(Object.entries(cache));
  }

  modify(_pos: [], { track, id }: TrackArgs['named']) {
    // take from args
    if (track) {
      this.data = track;
    }

    // ... anyway load from id
    else if (id && (!this.data || this.data?.id !== id)) {
      this.load(id);
    }
  }

  async load(id: string) {
    this.data = await this.spotify.client.api.getTrack(id);
  }

  async loadAnalysis() {
    if (this.data?.id) {
      if (this.#cache.has(this.data.id)) {
        this.analysis = this.#cache.get(this.data.id);
      } else {
        const analysis = await this.spotify.client.api.getAudioAnalysisForTrack(this.data.id);

        if (analysis) {
          this.#cache.set(this.data.id, analysis);
          this.analysis = analysis;
          this.persistCache();
        }
      }
    }
  }

  private persistCache() {
    const cache = Object.fromEntries(this.#cache.entries());

    localStorage.setItem('track-analysis', JSON.stringify(cache));
  }
}
