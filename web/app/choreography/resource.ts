import { ArgsWrapper, Resource } from 'ember-resources';
import { tracked } from '@glimmer/tracking';
import { service, Registry as Services } from '@ember/service';
import { Tag, Principle } from '../database/principles';

interface PrinciplesArgs extends ArgsWrapper {
  positional: [];
  named: {
    tag: Tag;
  };
}

export class PrinciplesResource extends Resource<PrinciplesArgs> {
  @service declare data: Services['data'];

  @tracked tag?: Tag;

  get all() {
    return this.data.find('principles');
  }

  get principles() {
    if (this.tag) {
      return this.filteredByTag(this.tag);
    }

    return this.all;
  }

  modify(_positional: [], { tag }: { tag: Tag }) {
    this.tag = tag;
  }

  private filteredByTag(tag: Tag) {
    return this.all.filter((principle: Principle) => {
      return principle.tags?.includes(tag);
    });
  }
}
