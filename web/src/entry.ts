import '@formatjs/intl-durationformat/polyfill';

import { bootRehydrated, installShoebox } from 'vite-ember-ssr/client';

import Application from './app';

installShoebox();
bootRehydrated(Application, {});
