import Component from '@glimmer/component';

import { Button } from '@hokulea/ember';

import { loadSystem } from './artistic/actions';
import { ArtisticResults } from './artistic/results';
import { IUF_PERFORMANCE_2019 } from './systems/iuf-performance-2019';

import type { JudgingSystem } from './artistic/domain-objects';
import type { RoutineTest } from './domain-objects';
import type Owner from '@ember/owner';
import type { Link } from 'ember-link';

interface RoutineResultsArgs {
  data?: RoutineTest;
  editLink?: Link;
}

export class RoutineResults extends Component<{
  Args: RoutineResultsArgs;
}> {
  artistic: JudgingSystem;

  constructor(owner: Owner, args: RoutineResultsArgs) {
    super(owner, args);

    this.artistic = loadSystem(IUF_PERFORMANCE_2019, args.data?.artistic);
  }

  <template>
    {{#if @data.artistic}}
      <ArtisticResults @system={{this.artistic}} />
    {{/if}}

    {{#if @editLink}}
      <Button @push={{@editLink}}>Bearbeiten</Button>
    {{/if}}
  </template>
}
