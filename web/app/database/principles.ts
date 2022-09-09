import { PrincipleWireFormat } from '@unidancing/database/principles.json';
import DataService from '../services/data';
import { Model } from './base';
import { ensureArray } from './utils';

export enum Tag {
  Choreo = 'choreography',
  Artistry = 'artistry',
  Tricks = 'tricks',
  Flow = 'flow',
  Posture = 'posture',
  Misc = 'misc'
}

export const TAGS = [...Object.values(Tag)];

export class Principle extends Model {
  #service: DataService;
  #raw: PrincipleWireFormat;

  tags: Tag[];
  #see?: Principle[];

  constructor(service: DataService, base: PrincipleWireFormat) {
    super(base);

    this.#service = service;
    this.#raw = base;

    this.tags = ensureArray(base.tags) as Tag[];
  }

  get see(): Principle[] | undefined {
    if (!this.#see) {
      this.#see = this.#raw.see
        ?.map((see) => {
          if (typeof see === 'string') {
            return this.#service.findOne('principles', see) as Principle;
          }

          return see;
        })
        .filter(Boolean);
    }

    return this.#see;
  }
}
