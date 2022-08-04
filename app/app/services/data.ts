import Service from '@ember/service';
import { Exercise } from '../database/exercises';
import { Skill } from '../database/skills';
import { load } from '../database/loader';
import { Model } from '../database/base';

export interface Databases {
  [key: string]: Model[];
  exercises: Exercise[];
  skills: Skill[];
}

export default class DataService extends Service {
  #data: Databases = load(this);

  find<K extends keyof Databases>(model: K): Databases[K] | undefined {
    return this.#data[model];
  }

  findOne<K extends keyof Databases>(
    model: K,
    id: string
  ): Databases[K][0] | undefined {
    // yep, this Databases[K][0] type looks so damn wrong !!!
    return this.#data[model]?.find((model: Model) => model.id === id);
  }
}

declare module '@ember/service' {
  interface Registry {
    data: DataService;
  }
}
