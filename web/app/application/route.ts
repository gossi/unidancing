import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { isDevelopingApp, isTesting, macroCondition } from '@embroider/macros';

import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import type FastBoot from 'ember-cli-fastboot/services/fastboot';
import type PageTitleService from 'ember-page-title/services/page-title';

export default class ApplicationRoute extends Route {
  @service declare router: RouterService;
  @service declare pageTitle: PageTitleService;
  @service declare fastboot: FastBoot;

  constructor(owner?: Owner) {
    super(owner);

    if (macroCondition(!isDevelopingApp() && !isTesting())) {
      this.pageTitle.titleDidUpdate = (title: string) => {
        const page = this.router.currentURL;
        const name = this.router.currentRouteName || 'unknown';

        try {
          // @ts-expect-error piwik types
          _paq.push(['setCustomUrl', page]);
          // @ts-expect-error piwik types
          _paq.push(['trackPageView', title.replace(' | UniDancing', '') ?? name]);
        } catch {
          // fastboot will report on document to not be defined, but also doesn't let
          // you check for it
        }
      };
    }
  }
}
