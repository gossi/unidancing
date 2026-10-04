import IntlService from 'ember-intl/services/intl';
import LinkManagerService from 'ember-link/services/link-manager';
import PageTitleService from 'ember-page-title/services/page-title';
import PortalService from 'ember-stargate/services/-portal';
import EmberApp from 'ember-strict-application-resolver';

import HokuleaService from '@hokulea/ember/services/-hokulea';

import config from './config/environment';
import Router from './router';

export default class App extends EmberApp {
  modulePrefix = config.modulePrefix;

  modules = {
    './router': Router,

    // Services looked up by string (via @service declarations in the app and
    // inside addon helpers like {{pageTitle}}). Add more here if a strict
    // lookup ever fails at runtime.
    './services/-hokulea': HokuleaService,
    './services/-portal': PortalService,
    './services/intl': IntlService,
    './services/link-manager': LinkManagerService,
    './services/page-title': PageTitleService,

    // Everything resolvable by convention from the app tree; the route
    // subtrees registered as lazy bundles in route-splitting.ts are loaded
    // on demand instead.
    ...import.meta.glob(
      [
        './{routes,templates,controllers,services}/**/*.{js,ts,gjs,gts}',
        '!./routes/courses.gts',
        '!./routes/courses/**',
        '!./routes/skills/**',
        '!./routes/exercises.gts',
        '!./routes/exercises/**',
        '!./routes/moves.gts',
        '!./routes/moves/**',
        '!./routes/choreography.gts',
        '!./routes/choreography/**',
        '!./routes/training.gts',
        '!./routes/training/**'
      ],
      { eager: true }
    )
  };
}
