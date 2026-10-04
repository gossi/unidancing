import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { isDevelopingApp, isTesting, macroCondition } from '@embroider/macros';

import translationsDe from 'virtual:ember-intl/translations/de';

import { isSSR } from '../domain/supporting/utils';

import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import type { IntlService } from 'ember-intl';
import type PageTitleService from 'ember-page-title/services/page-title';

export default class ApplicationRoute extends Route {
  @service declare router: RouterService;
  @service declare pageTitle: PageTitleService;
  @service declare intl: IntlService;

  constructor(owner?: Owner) {
    super(owner);

    this.intl.addTranslations('de', translationsDe);
    this.intl.setLocale('de');

    if (
      macroCondition(!isDevelopingApp() && !isTesting()) && // analytics scripts would be baked into every prerendered page and run
      // twice on rehydrated boots; only inject in the browser
      !isSSR()
    ) {
      try {
        const _paq = (globalThis._paq = globalThis._paq || []);

        /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
        _paq.push(['enableLinkTracking']);

        (function () {
          const u = 'https://analytics.otherwheel.com/';

          _paq.push(['setTrackerUrl', u + 'js/index.php'], ['setSiteId', '6']);

          const d = document,
            g = d.createElement('script'),
            s = d.querySelector('script');

          g.async = true;
          g.src = u + 'js/index.php';
          (s.parentNode as HTMLElement).insertBefore(g, s);
        })();

        this.pageTitle.titleDidUpdate = (title: string) => {
          const page = this.router.currentURL;

          try {
            _paq.push(['setCustomUrl', page]);
            _paq.push(['trackPageView', title.replace(' | UniDancing', '')]);
          } catch {
            //
          }
        };
      } catch {
        //
      }
    }

    // xstate inspector
    // if (macroCondition(isDevelopingApp())) {
    //   if (!isSSR()) {
    //     const { inspect } = importSync('@xstate/inspect') as { inspect: typeof Inspect };

    //     inspect({
    //       // options
    //       // URL: 'https://stately.ai/viz?inspect', // (default)
    //       iframe: false // open in new window
    //     });
    //   }
    // }
  }
}
