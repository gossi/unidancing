import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { isDevelopingApp, isTesting, macroCondition } from '@embroider/macros';

import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import type FastBoot from 'ember-cli-fastboot/services/fastboot';
import type { IntlService } from 'ember-intl';
import type PageTitleService from 'ember-page-title/services/page-title';

export default class ApplicationRoute extends Route {
  @service declare router: RouterService;
  @service declare pageTitle: PageTitleService;
  @service declare fastboot: FastBoot;
  @service declare intl: IntlService;

  constructor(owner?: Owner) {
    super(owner);

    this.intl.setLocale('de');

    if (macroCondition(!isDevelopingApp() && !isTesting())) {
      try {
        // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition, @typescript-eslint/naming-convention
        let _paq = (window._paq = window._paq || []);

        /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
        _paq.push(['enableLinkTracking']);

        (function () {
          let u = 'https://analytics.otherwheel.com/';

          _paq.push(['setTrackerUrl', u + 'js/index.php']);
          _paq.push(['setSiteId', '6']);

          let d = document,
            g = d.createElement('script'),
            s = d.getElementsByTagName('script')[0];

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
            // fastboot will report on document to not be defined, but also doesn't let
            // you check for it
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
    //       // url: 'https://stately.ai/viz?inspect', // (default)
    //       iframe: false // open in new window
    //     });
    //   }
    // }
  }
}
