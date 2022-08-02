import Service from '@ember/service';
import { load, Databases } from '../database/loader';

export default class DataService extends Service {
  #data: Databases = load();

  find<K = keyof Databases>(model: K): Databases[K] | undefined {
    return this.#data[model];
  }

  findOne<K = keyof Databases>(model: K, id: string): Databases[K] | undefined {
    return this.#data[model]?.find((model) => model.id === id);
  }
}
