import { pageTitle } from 'ember-page-title';
import { findArts } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { ArtTree } from '../-components';
import styles from './styles.css';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class ArtsIndexRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  get arts() {
    const promise = use(this, findArts()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{pageTitle "Künste"}}

    <h1>Künste</h1>

    <p>Kunstformen die für UniDancing und deren Umsetzung auf dem Einrad
    geeignet sind.</p>

    {{#let this.arts as |r|}}
      {{#if r.resolved}}
        <div class={{styles.layout}}>
          <ArtTree @arts={{r.value}}/>

          {{outlet}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(ArtsIndexRoute);
