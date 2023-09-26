import { Model } from './base';

import type DataService from '../services/data';
import type { Skill } from './skills';
import type { Game, Link, MoveWireFormat } from '@unidancing/database/moves.json';

type See = Link | Move;

interface Video {
  type: string;
  url: string;
}

export type { Game, See };

export class Move extends Model {
  #service: DataService;
  #raw: MoveWireFormat;

  tags?: string[];
  games?: Game[];

  video?: Video;

  #skills?: Skill[];
  #see?: See[];

  constructor(service: DataService, base: MoveWireFormat) {
    super(base);

    this.#service = service;
    this.#raw = base;

    this.tags = base.tags;
    this.games = base.games;
    this.video = base.video;
  }

  get see(): See[] | undefined {
    if (!this.#see) {
      this.#see = this.#raw.see
        ?.map((see: string | See) => {
          if (typeof see === 'string') {
            return this.#service.findOne('moves', see) as Move;
          }

          return see;
        })
        .filter(Boolean);
    }

    return this.#see;
  }

  get skills(): Skill[] | undefined {
    if (!this.#skills) {
      this.#skills = this.#raw.skills
        ?.map((skill: string) => {
          return this.#service.findOne('skills', skill) as Skill;
        })
        .filter(Boolean);
    }

    return this.#skills;
  }
}
