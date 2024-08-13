import Route from '@ember/routing/route';
import { service } from '@ember/service';

import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import type PageTitleService from 'ember-page-title/services/page-title';

export default class ApplicationRoute extends Route {
  @service declare router: RouterService;
  @service declare pageTitle: PageTitleService;

  constructor(owner?: Owner) {
    super(owner);

    this.pageTitle.titleDidUpdate = (title: string) => {
      const page = this.router.currentURL;
      const name = this.router.currentRouteName || 'unknown';

      try {
        // @ts-expect-error piwik types
        _paq.push(['setCustomUrl', page]);
        // @ts-expect-error piwik types
        _paq.push(['setDocumentTitle', title.replace(' | UniDancing', '')]);
        // @ts-expect-error piwik types
        _paq.push(['trackPageView', name]);
      } catch {
        // fastboot will report on document to not be defined, but also doesn't let
        // you check for it
      }
    };
  }
}
