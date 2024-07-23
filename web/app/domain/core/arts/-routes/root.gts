import { cached } from '@glimmer/tracking';
import { service } from '@ember/service';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { ArtTree } from '../-components';
import { findArts } from '../-resource';
import styles from './styles.css';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class ArtsIndexRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findArts()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{pageTitle 'Künste'}}

    <Page @title="Künste" @description="Kunstformen die für UniDancing und deren Umsetzung auf dem Einrad geeignet sind.">
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          <div class={{styles.layout}}>
            <ArtTree @arts={{r.value}} />

            {{outlet}}
          </div>
        {{/if}}
      {{/let}}
    </Page>
  </template>
}

export default CompatRoute(ArtsIndexRoute);
