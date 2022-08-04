import { SkillWireFormat } from '@unidance-coach/database/skills.json';
import DataService from '../services/data';
import { Model } from './base';

export class Skill extends Model {
  #service: DataService;
  #raw: SkillWireFormat;

  constructor(service: DataService, base: SkillWireFormat) {
    super(base);

    this.#service = service;
    this.#raw = base;
  }
}
