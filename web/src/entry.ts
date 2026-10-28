import '@formatjs/intl-durationformat/polyfill';

import { bootRehydrated, installShoebox } from 'vite-ember-ssr/client';

import Application from './app';
import config from './config/environment';

installShoebox();
bootRehydrated(Application, config);
