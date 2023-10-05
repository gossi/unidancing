import Service from '@ember/service';

import { load } from '../database/loader';

import type { Model } from '../database/base';
import type { Course } from '../database/courses';
import type { Exercise } from '../database/exercises';
import type { Move } from '../database/moves';
import type { Principle } from '../database/principles';
import type { Skill } from '../database/skills';

export interface Databases {
  [key: string]: Model[];
  exercises: Exercise[];
  skills: Skill[];
  principles: Principle[];
  moves: Move[];
  courses: Course[];
}

export default class DataService extends Service {
  #data: Databases = load(this);

  find<K extends keyof Databases>(model: K): Databases[K] {
    return this.#data[model];
  }

  findOne<K extends keyof Databases>(model: K, id: string): Databases[K][0] | undefined {
    // yep, this Databases[K][0] type looks so damn wrong !!!
    return this.#data[model]?.find((model: Model) => model.id === id);
  }
}

declare module '@ember/service' {
  interface Registry {
    data: DataService;
  }
}
