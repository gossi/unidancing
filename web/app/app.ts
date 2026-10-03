import EmberApp from 'ember-strict-application-resolver';

import IntlService from 'ember-intl/services/intl';
import PageTitleService from 'ember-page-title/services/page-title';

import config from './config/environment';
import Router from './router';

export default class App extends EmberApp {
  modulePrefix = config.modulePrefix;

  modules = {
    './router': Router,

    // Services looked up by string (via @service declarations in the app and
    // inside addon helpers like {{pageTitle}}). Add more here if a strict
    // lookup ever fails at runtime.
    './services/intl': IntlService,
    './services/page-title': PageTitleService,

    // Everything resolvable by convention from the app tree
    ...import.meta.glob('./{routes,templates,controllers,services}/**/*.{js,ts,gjs,gts}', {
      eager: true
    })
  };
}
