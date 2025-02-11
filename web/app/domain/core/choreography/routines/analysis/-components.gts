import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

import { IconButton, Popover, popover, Tabs, TextInput } from '@hokulea/ember';

import { copyToClipboard, selectWhenFocus } from '../-utils';
import { canUseForTraining, makeTrainingLink } from './domain-objects';
import styles from './styles.css';

import type { RoutineResult } from './domain-objects';
import type { TOC } from '@ember/component/template-only';
import type RouterService from '@ember/routing/router-service';

export class Share extends Component<{
  Args: {
    routine: RoutineResult;
  };
}> {
  @service declare router: RouterService;

  get shareLink() {
    try {
      return window.location.href;
    } catch {
      return '';
    }
  }

  <template>
    {{#let (popover position="bottom-start") as |po|}}
      <IconButton
        @icon="share-fat"
        @importance="subtle"
        @spacing="-1"
        @label="Teilen"
        {{po.trigger}}
      />

      <Popover {{po.target}} class={{styles.share}}>
        <Tabs as |tab|>
          <tab.Tab @label="Link">
            <p>Teile den Link zur Kür-Analyse:</p>
            <div>
              <TextInput @value={{this.shareLink}} readonly {{selectWhenFocus}} />
              <IconButton
                @icon="clipboard-text"
                @importance="subtle"
                @spacing="-1"
                @label="Kopieren"
                @push={{fn copyToClipboard this.shareLink}}
              />
            </div>
          </tab.Tab>

          {{#if (canUseForTraining @routine)}}
            {{#let (makeTrainingLink @routine this.router) as |trainingLink|}}
              <tab.Tab @label="Training">
                <p>Teile den Link zur Kür-Analyse:</p>
                <div>
                  <TextInput @value={{trainingLink}} readonly {{selectWhenFocus}} />
                  <IconButton
                    @icon="clipboard-text"
                    @importance="subtle"
                    @spacing="-1"
                    @label="Kopieren"
                    @push={{fn copyToClipboard trainingLink}}
                  />
                </div>
              </tab.Tab>
            {{/let}}
          {{/if}}
        </Tabs>
      </Popover>
    {{/let}}
  </template>
}

const Toolbar: TOC<{ Blocks: { default: [] } }> = <template>
  <p class={{styles.toolbar}}>
    {{yield}}
  </p>
</template>;

export { Toolbar };
