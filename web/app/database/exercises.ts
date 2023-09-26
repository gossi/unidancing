import { Model } from './base';
import { ensureArray } from './utils';

import type DataService from '../services/data';
import type { Skill } from './skills';
import type {
  ExerciseWireFormat,
  Game,
  Link,
  Locomotion,
  Personal
} from '@unidancing/database/exercises.json';

type See = Link | Exercise;

export type { Game, Locomotion, Personal, See };

export class Exercise extends Model {
  #service: DataService;
  #raw: ExerciseWireFormat;

  personal?: Personal[];
  locomotion?: Locomotion[];
  tags?: string[];
  games?: Game[];

  #skills?: Skill[];
  #see?: See[];

  constructor(service: DataService, base: ExerciseWireFormat) {
    super(base);

    this.#service = service;
    this.#raw = base;

    this.tags = base.tags;
    this.personal = ensureArray<Personal>(base.personal);
    this.locomotion = ensureArray<Locomotion>(base.locomotion);
    this.games = base.games;
  }

  get see(): See[] | undefined {
    if (!this.#see) {
      this.#see = this.#raw.see
        ?.map((see) => {
          if (typeof see === 'string') {
            return this.#service.findOne('exercises', see) as Exercise;
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
        ?.map((skill) => {
          return this.#service.findOne('skills', skill) as Skill;
        })
        .filter(Boolean);
    }

    return this.#skills;
  }
}
