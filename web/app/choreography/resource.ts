import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import type { Awfulpractice, Tag } from '.';
import type { AwfulpracticeConnectionQueryVariables } from '@/tina/types';

// import { tracked } from '@glimmer/tracking';
// import { service } from '@ember/service';

// import { Resource } from 'ember-resources';

// import type { Principle, Tag } from '../database/principles';
// import type { Registry as Services } from '@ember/service';
// import type { ArgsWrapper } from 'ember-resources';

// interface PrinciplesArgs extends ArgsWrapper {
//   positional: [];
//   named: {
//     tag?: Tag;
//   };
// }

// export class PrinciplesResource extends Resource<PrinciplesArgs> {
//   @service declare data: Services['data'];

//   @tracked tag?: Tag;

//   get all() {
//     return this.data.find('principles');
//   }

//   get principles() {
//     if (this.tag) {
//       return this.filteredByTag(this.tag);
//     }

//     return this.all;
//   }

//   modify(_positional: [], { tag }: { tag: Tag }) {
//     this.tag = tag;
//   }

//   private filteredByTag(tag: Tag) {
//     return this.all.filter((principle: Principle) => {
//       return principle.tags?.includes(tag);
//     });
//   }
// }

export const findAwfulPractices = resourceFactory((tag?: Tag) => {
  return resource(async ({ owner }): Promise<Awfulpractice[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const options: AwfulpracticeConnectionQueryVariables = {
      sort: 'title'
    };

    if (tag) {
      options.filter = {
        tags: {
          in: [tag]
        }
      };
    }

    const apResponse = await tina.client.queries.awfulpracticeConnection(options);

    return apResponse.data.awfulpracticeConnection.edges?.map((ap) => ap?.node) as Awfulpractice[];
  });
});
